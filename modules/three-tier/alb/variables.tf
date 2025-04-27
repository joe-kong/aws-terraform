variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where ALB will be created"
  type        = string
}

variable "public_subnet_ids" {
  description = "IDs of public subnets for ALB"
  type        = list(string)
}

# セキュリティグループ関連の変数
variable "alb_security_group_id" {
  description = "ID of security group for ALB"
  type        = string
}

# ヘルスチェックパス
variable "health_check_path" {
  description = "Path for ALB health checks"
  type        = string
  default     = "/"
}
# 削除保護するかどうか
variable "enable_deletion_protection" {
  description = "Whether to enable deletion protection for ALB"
  type        = bool
  default     = false
}

variable "stickiness_enabled" {
  description = "Whether to enable stickiness for ALB target group"
  type        = bool
  default     = false
}

variable "redirect_http_to_https" {
  description = "Whether to redirect HTTP traffic to HTTPS"
  type        = bool
  default     = false
}

variable "acm_certificate_arn" {
  description = "ARN of ACM certificate for HTTPS listener"
  type        = string
  default     = ""
}

variable "access_logs_bucket" {
  description = "S3 bucket name for ALB access logs"
  type        = string
  default     = ""
} 