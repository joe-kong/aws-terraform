variable "name_prefix" {
  description = "リソース名のプレフィックス"
  type        = string
}

variable "vpc_id" {
  description = "ALBを作成するVPC ID"
  type        = string
}

variable "subnet_ids" {
  description = "ALBを作成するサブネットIDのリスト"
  type        = list(string)
}

variable "security_group_ids" {
  description = "ALBに関連付けるセキュリティグループIDのリスト"
  type        = list(string)
}

variable "internal" {
  description = "ALBが内部向けかどうか"
  type        = bool
  default     = false
}

variable "enable_deletion_protection" {
  description = "ALBの削除保護を有効にするかどうか"
  type        = bool
  default     = false
}

variable "enable_http2" {
  description = "HTTP/2を有効にするかどうか"
  type        = bool
  default     = true
}

variable "idle_timeout" {
  description = "ALBのアイドルタイムアウト（秒）"
  type        = number
  default     = 60
}

variable "ip_address_type" {
  description = "ALBのIPアドレスタイプ（ipv4またはdualstack）"
  type        = string
  default     = "ipv4"
}

variable "access_logs" {
  description = "アクセスログの設定"
  type = object({
    bucket  = string
    prefix  = string
    enabled = bool
  })
  default = {
    bucket  = ""
    prefix  = ""
    enabled = false
  }
}

variable "enable_https" {
  description = "HTTPSリスナーを作成するかどうか"
  type        = bool
  default     = false
}

variable "ssl_certificate_arn" {
  description = "HTTPSリスナー用のSSL証明書ARN"
  type        = string
  default     = ""
}

variable "ssl_policy" {
  description = "HTTPSリスナー用のSSLポリシー"
  type        = string
  default     = "ELBSecurityPolicy-2016-08"
}

variable "http_redirect_to_https" {
  description = "HTTPからHTTPSへのリダイレクトを有効にするかどうか"
  type        = bool
  default     = false
}

variable "target_groups" {
  description = "作成するターゲットグループの設定"
  type = map(object({
    port                 = number
    protocol             = string
    target_type          = string
    deregistration_delay = number
    health_check = object({
      enabled             = bool
      path                = string
      port                = string
      protocol            = string
      healthy_threshold   = number
      unhealthy_threshold = number
      timeout             = number
      interval            = number
      matcher             = string
    })
    stickiness = object({
      enabled         = bool
      type            = string
      cookie_duration = number
    })
  }))
  default = {}
}

variable "tags" {
  description = "全リソースに追加するタグ"
  type        = map(string)
  default     = {}
} 