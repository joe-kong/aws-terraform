variable "name_prefix" {
  description = "リソース名のプレフィックス"
  type        = string
}

variable "enable_container_insights" {
  description = "ECSクラスターのContainer Insightsを有効にするかどうか"
  type        = bool
  default     = true
}

variable "log_retention_days" {
  description = "CloudWatchログの保持日数"
  type        = number
  default     = 30
}

variable "tags" {
  description = "全リソースに追加するタグ"
  type        = map(string)
  default     = {}
} 