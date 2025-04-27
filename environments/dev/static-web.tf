module "static_web" {
  source = "../../modules/static-web"

  project_name = "myapp"
  environment  = "dev"

  # S3バケット設定
  bucket_name      = "myapp-dev-website"
  enable_versioning = true

  # CloudFront設定
  default_root_object    = "index.html"
  cloudfront_price_class = "PriceClass_100" # 北米、欧州のみ対象（コスト最適化）
  
  # TTL設定
  min_ttl     = 0
  default_ttl = 3600    # 1時間
  max_ttl     = 86400   # 24時間

  # 地理的制限
  geo_restriction_type      = "none"
  geo_restriction_locations = []

  # エラーレスポンス
  custom_error_responses = [
    {
      error_code         = 404
      response_code      = 200
      response_page_path = "/index.html"  # SPAの場合に役立つ
    },
    {
      error_code         = 403
      response_code      = 200
      response_page_path = "/index.html"
    }
  ]

  # SSL/TLS設定
  create_certificate       = true
  custom_domain            = "dev.myapp.example.com"
  hosted_zone_name         = "example.com"
  subject_alternative_names = []

  # CloudFrontの自動無効化Lambda関数
  create_invalidation_lambda = true

  # タグ
  tags = {
    Environment = "dev"
    Project     = "myapp"
    ManagedBy   = "terraform"
  }
} 