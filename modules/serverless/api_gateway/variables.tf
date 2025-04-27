variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "description" {
  description = "Description for the API Gateway"
  type        = string
  default     = "API Gateway for Serverless Application"
}

variable "stage_name" {
  description = "Stage name for API Gateway"
  type        = string
  default     = "dev"
}

variable "logging_level" {
  description = "Logging level for API Gateway (OFF, ERROR, INFO)"
  type        = string
  default     = "INFO"
}

variable "metrics_enabled" {
  description = "Whether to enable metrics for API Gateway"
  type        = bool
  default     = true
}

variable "xray_tracing_enabled" {
  description = "Whether to enable X-Ray tracing for API Gateway"
  type        = bool
  default     = false
}

variable "throttling_rate_limit" {
  description = "Rate limit for API Gateway throttling"
  type        = number
  default     = 10000
}

variable "throttling_burst_limit" {
  description = "Burst limit for API Gateway throttling"
  type        = number
  default     = 5000
}

variable "cors_allow_origins" {
  description = "List of allowed origins for CORS"
  type        = list(string)
  default     = ["*"]
}

variable "cors_allow_methods" {
  description = "List of allowed methods for CORS"
  type        = list(string)
  default     = ["GET", "POST", "PUT", "DELETE", "OPTIONS"]
}

variable "cors_allow_headers" {
  description = "List of allowed headers for CORS"
  type        = list(string)
  default     = ["Content-Type", "Authorization", "X-Amz-Date", "X-Api-Key", "X-Amz-Security-Token"]
}

variable "cors_max_age" {
  description = "Max age for CORS in seconds"
  type        = number
  default     = 7200
}

variable "domain_name" {
  description = "Custom domain name for API Gateway"
  type        = string
  default     = ""
}

variable "certificate_arn" {
  description = "ACM certificate ARN for API Gateway custom domain"
  type        = string
  default     = ""
} 