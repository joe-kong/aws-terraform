variable "project_name" {
  description = "プロジェクト名（リソース名のプレフィックスに使用）"
  type        = string
}

variable "environment" {
  description = "環境名（開発、ステージング、本番など）"
  type        = string
}

# S3関連の変数
variable "bucket_name" {
  description = "S3バケット名"
  type        = string
}

variable "enable_versioning" {
  description = "S3バケットのバージョニングを有効にするかどうか"
  type        = bool
  default     = false
}

# CloudFront関連の変数
variable "default_root_object" {
  description = "CloudFrontのデフォルトルートオブジェクト"
  type        = string
  default     = "index.html"
}

variable "cloudfront_price_class" {
  description = "CloudFrontの価格クラス（PriceClass_100、PriceClass_200、PriceClass_All）"
  type        = string
  default     = "PriceClass_100"
}

variable "min_ttl" {
  description = "CloudFrontキャッシュの最小TTL（秒）"
  type        = number
  default     = 0
}

variable "default_ttl" {
  description = "CloudFrontキャッシュのデフォルトTTL（秒）"
  type        = number
  default     = 3600 # 1時間
}

variable "max_ttl" {
  description = "CloudFrontキャッシュの最大TTL（秒）"
  type        = number
  default     = 86400 # 24時間
}

variable "geo_restriction_type" {
  description = "地理的制限のタイプ（none、blacklist、whitelist）"
  type        = string
  default     = "none"
}

variable "geo_restriction_locations" {
  description = "地理的制限の国コードリスト"
  type        = list(string)
  default     = []
}

variable "custom_error_responses" {
  description = "CloudFrontのカスタムエラーレスポンス"
  type = list(object({
    error_code         = number
    response_code      = number
    response_page_path = string
  }))
  default = [
    {
      error_code         = 404
      response_code      = 200
      response_page_path = "/index.html"
    },
    {
      error_code         = 403
      response_code      = 200
      response_page_path = "/index.html"
    }
  ]
}

variable "web_acl_id" {
  description = "WAF Web ACL ID to associate with CloudFront distribution"
  type        = string
  default     = ""
}

variable "log_bucket" {
  description = "S3 bucket for CloudFront access logs"
  type        = string
  default     = ""
}

# SSL/TLS関連の変数
variable "create_certificate" {
  description = "ACM証明書を作成するかどうか"
  type        = bool
  default     = false
}

variable "acm_certificate_arn" {
  description = "ARN of existing ACM certificate to use with CloudFront"
  type        = string
  default     = ""
}

variable "custom_domain" {
  description = "カスタムドメイン名"
  type        = string
  default     = ""
}

variable "hosted_zone_id" {
  description = "Route53 hosted zone ID for DNS records"
  type        = string
  default     = ""
}

variable "hosted_zone_name" {
  description = "Route53ホストゾーン名（例：example.com）"
  type        = string
  default     = ""
}

variable "subject_alternative_names" {
  description = "ACM証明書のSAN（Subject Alternative Names）"
  type        = list(string)
  default     = []
}

# Lambda関連の変数
variable "create_invalidation_lambda" {
  description = "CloudFront無効化用のLambda関数を作成するかどうか"
  type        = bool
  default     = false
}

# タグ
variable "tags" {
  description = "リソースに設定するタグ"
  type        = map(string)
  default     = {}
} 