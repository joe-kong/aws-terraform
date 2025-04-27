locals {
  name_prefix = "${var.project_name}-${var.environment}"
  domain_name = var.custom_domain != "" ? var.custom_domain : "${local.name_prefix}.${var.hosted_zone_name}"

  # OAIの代わりにコントロールアクセスポリシー（CAP）を使用
  create_origin_access_control = true

  # S3オリジンID
  s3_origin_id = "${var.project_name}-${var.environment}-origin"

  # Priceクラスの選択 (コスト最適化)
  price_class = var.cloudfront_price_class

  # エラーページ設定
  custom_error_responses = var.custom_error_responses
}

# S3 バケット - ウェブサイトコンテンツを保存
resource "aws_s3_bucket" "website" {
  bucket = var.bucket_name
  
  tags = merge(
    var.tags,
    {
      Name = var.bucket_name
    }
  )
}

# S3バケットのバージョニング設定
resource "aws_s3_bucket_versioning" "website" {
  bucket = aws_s3_bucket.website.id
  
  versioning_configuration {
    status = var.enable_versioning ? "Enabled" : "Suspended"
  }
}

# S3バケットの公開アクセスブロック設定 (セキュリティベストプラクティス)
resource "aws_s3_bucket_public_access_block" "website" {
  bucket = aws_s3_bucket.website.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# S3バケットポリシー - CloudFrontからのアクセスのみを許可
resource "aws_s3_bucket_policy" "website" {
  bucket = aws_s3_bucket.website.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowCloudFrontServicePrincipal"
        Effect    = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.website.arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.website.arn
          }
        }
      }
    ]
  })
}

# CloudFront用のオリジンアクセスコントロール
resource "aws_cloudfront_origin_access_control" "website" {
  name                              = "${var.project_name}-${var.environment}-oac"
  description                       = "OAC for ${var.bucket_name}"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# SSL証明書
resource "aws_acm_certificate" "cert" {
  count = var.create_certificate ? 1 : 0
  
  provider = aws.us_east_1
  domain_name       = var.custom_domain
  validation_method = "DNS"
  subject_alternative_names = var.subject_alternative_names

  lifecycle {
    create_before_destroy = true
  }

  tags = var.tags
}

# DNSレコードによる証明書検証
resource "aws_route53_record" "cert_validation" {
  for_each = var.create_certificate ? {
    for dvo in aws_acm_certificate.cert[0].domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  } : {}

  zone_id = data.aws_route53_zone.selected[0].zone_id
  name    = each.value.name
  type    = each.value.type
  records = [each.value.record]
  ttl     = 60
}

# Route53ホストゾーンの取得
data "aws_route53_zone" "selected" {
  count = var.create_certificate ? 1 : 0
  
  name         = var.hosted_zone_name
  private_zone = false
}

# 証明書検証の完了を待機
resource "aws_acm_certificate_validation" "cert" {
  count = var.create_certificate ? 1 : 0
  
  provider = aws.us_east_1
  certificate_arn         = aws_acm_certificate.cert[0].arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}

# CloudFront Distribution
resource "aws_cloudfront_distribution" "website" {
  origin {
    domain_name              = aws_s3_bucket.website.bucket_regional_domain_name
    origin_id                = local.s3_origin_id
    origin_access_control_id = aws_cloudfront_origin_access_control.website.id
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = var.default_root_object
  price_class         = local.price_class
  aliases             = var.create_certificate ? [var.custom_domain] : []

  # キャッシュ設定
  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = var.min_ttl
    default_ttl            = var.default_ttl
    max_ttl                = var.max_ttl
    compress               = true
  }

  # 地理的制限（必要な場合）
  dynamic "restrictions" {
    for_each = length(var.geo_restriction_locations) > 0 ? [1] : []
    content {
      geo_restriction {
        restriction_type = var.geo_restriction_type
        locations        = var.geo_restriction_locations
      }
    }
  }

  # SSL証明書設定
  viewer_certificate {
    cloudfront_default_certificate = var.create_certificate ? false : true
    acm_certificate_arn            = var.create_certificate ? aws_acm_certificate.cert[0].arn : null
    ssl_support_method             = var.create_certificate ? "sni-only" : null
    minimum_protocol_version       = var.create_certificate ? "TLSv1.2_2021" : null
  }

  # カスタムエラーレスポンス
  dynamic "custom_error_response" {
    for_each = local.custom_error_responses
    content {
      error_code            = custom_error_response.value.error_code
      response_code         = custom_error_response.value.response_code
      response_page_path    = custom_error_response.value.response_page_path
      error_caching_min_ttl = custom_error_response.value.error_caching_min_ttl
    }
  }

  # WAF関連付け（オプション）
  web_acl_id = var.web_acl_id

  # ログ記録
  dynamic "logging_config" {
    for_each = var.log_bucket != "" ? [1] : []
    content {
      include_cookies = false
      bucket          = "${var.log_bucket}.s3.amazonaws.com"
      prefix          = "${local.name_prefix}/"
    }
  }

  tags = var.tags

  depends_on = [
    aws_acm_certificate_validation.cert
  ]
}

# Route53レコード（カスタムドメイン用）
resource "aws_route53_record" "website" {
  count = var.create_certificate ? 1 : 0
  
  zone_id = data.aws_route53_zone.selected[0].zone_id
  name    = var.custom_domain
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.website.domain_name
    zone_id                = aws_cloudfront_distribution.website.hosted_zone_id
    evaluate_target_health = false
  }
}

# CloudFront Invalidation Lambda Function (オプション)
resource "aws_lambda_function" "invalidation" {
  count = var.create_invalidation_lambda ? 1 : 0
  
  function_name    = "${var.project_name}-${var.environment}-cf-invalidation"
  filename         = "${path.module}/lambda/invalidation.zip"
  handler          = "index.handler"
  role             = aws_iam_role.lambda_role[0].arn
  runtime          = "nodejs16.x"
  timeout          = 60
  memory_size      = 128

  environment {
    variables = {
      DISTRIBUTION_ID = aws_cloudfront_distribution.website.id
    }
  }

  tags = var.tags
}

# Lambda実行ロール
resource "aws_iam_role" "lambda_role" {
  count = var.create_invalidation_lambda ? 1 : 0
  
  name = "${var.project_name}-${var.environment}-lambda-cf-invalidation-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = var.tags
}

# CloudFront Invalidation権限
resource "aws_iam_policy" "lambda_policy" {
  count = var.create_invalidation_lambda ? 1 : 0
  
  name        = "${var.project_name}-${var.environment}-lambda-cf-invalidation-policy"
  description = "Allow Lambda to invalidate CloudFront and write logs"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "cloudfront:CreateInvalidation"
        Resource = aws_cloudfront_distribution.website.arn
      },
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

# ポリシーのアタッチ
resource "aws_iam_role_policy_attachment" "lambda_attachment" {
  count = var.create_invalidation_lambda ? 1 : 0
  
  role       = aws_iam_role.lambda_role[0].name
  policy_arn = aws_iam_policy.lambda_policy[0].arn
}

# S3バケットへのイベント通知（オブジェクト作成/削除時）
resource "aws_s3_bucket_notification" "bucket_notification" {
  count = var.create_invalidation_lambda ? 1 : 0
  
  bucket = aws_s3_bucket.website.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.invalidation[0].arn
    events              = ["s3:ObjectCreated:*", "s3:ObjectRemoved:*"]
  }
}

# S3バケットからLambdaを呼び出す許可
resource "aws_lambda_permission" "allow_bucket" {
  count = var.create_invalidation_lambda ? 1 : 0
  
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.invalidation[0].function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.website.arn
} 