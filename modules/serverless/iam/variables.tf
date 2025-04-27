variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "logs_retention_days" {
  description = "Number of days to retain CloudWatch logs"
  type        = number
  default     = 30
} 