output "bucket_id" {
  description = "作成されたS3バケットのID"
  value       = aws_s3_bucket.this.id
}

output "bucket_arn" {
  description = "作成されたS3バケットのARN"
  value       = aws_s3_bucket.this.arn
}

output "bucket_domain_name" {
  description = "S3バケットのドメイン名"
  value       = aws_s3_bucket.this.bucket_domain_name
}

output "bucket_regional_domain_name" {
  description = "S3バケットのリージョナルドメイン名"
  value       = aws_s3_bucket.this.bucket_regional_domain_name
}

output "website_domain" {
  description = "ウェブサイトのドメイン名"
  value       = var.create_certificate && var.custom_domain != "" ? var.custom_domain : aws_cloudfront_distribution.this.domain_name
}

output "cloudfront_distribution_id" {
  description = "CloudFrontディストリビューションのID"
  value       = aws_cloudfront_distribution.this.id
}

output "cloudfront_distribution_arn" {
  description = "CloudFrontディストリビューションのARN"
  value       = aws_cloudfront_distribution.this.arn
}

output "cloudfront_distribution_domain_name" {
  description = "CloudFrontディストリビューションのドメイン名"
  value       = aws_cloudfront_distribution.this.domain_name
}

output "cloudfront_distribution_hosted_zone_id" {
  description = "CloudFrontディストリビューションのホストゾーンID"
  value       = aws_cloudfront_distribution.this.hosted_zone_id
}

output "cloudfront_distribution_status" {
  description = "CloudFrontディストリビューションのステータス"
  value       = aws_cloudfront_distribution.this.status
}

output "acm_certificate_arn" {
  description = "作成されたACM証明書のARN（証明書が作成された場合）"
  value       = var.create_certificate ? aws_acm_certificate.this[0].arn : ""
}

output "acm_certificate_status" {
  description = "ACM証明書のステータス"
  value       = var.create_certificate ? aws_acm_certificate.this[0].status : null
}

output "dns_record_name" {
  description = "Route53レコードの名前"
  value       = var.hosted_zone_id != "" && var.custom_domain != "" ? aws_route53_record.website[0].name : null
}

output "dns_record_fqdn" {
  description = "Route53レコードの完全修飾ドメイン名"
  value       = var.hosted_zone_id != "" && var.custom_domain != "" ? aws_route53_record.website[0].fqdn : null
}

output "website_url" {
  description = "ウェブサイトのURL"
  value       = var.custom_domain != "" ? "https://${var.custom_domain}" : "https://${aws_cloudfront_distribution.this.domain_name}"
}

output "invalidation_lambda_arn" {
  description = "CloudFront無効化Lambda関数のARN（Lambda関数が作成された場合）"
  value       = var.create_invalidation_lambda ? aws_lambda_function.invalidation[0].arn : ""
}

output "invalidation_lambda_function_name" {
  description = "CloudFront無効化Lambda関数の名前"
  value       = var.create_invalidation_lambda ? aws_lambda_function.invalidation[0].function_name : null
}

output "route53_record_name" {
  description = "作成されたRoute53レコード名（カスタムドメインとホストゾーンが設定された場合）"
  value       = var.create_certificate && var.custom_domain != "" && var.hosted_zone_name != "" ? aws_route53_record.web[0].name : ""
} 