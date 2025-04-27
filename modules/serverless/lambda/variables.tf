variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "handler" {
  description = "Lambda function handler"
  type        = string
  default     = "index.handler"
}

variable "runtime" {
  description = "Lambda function runtime"
  type        = string
  default     = "nodejs18.x"
}

variable "timeout" {
  description = "Lambda function timeout in seconds"
  type        = number
  default     = 30
}

variable "memory_size" {
  description = "Lambda function memory size in MB"
  type        = number
  default     = 128
}

variable "source_path" {
  description = "Path to Lambda function source code"
  type        = string
  default     = null
}

variable "environment_variables" {
  description = "Environment variables for Lambda function"
  type        = map(string)
  default     = {}
}

variable "execution_role_arn" {
  description = "ARN of IAM role for Lambda function"
  type        = string
}

variable "create_in_vpc" {
  description = "Whether to create Lambda function in VPC"
  type        = bool
  default     = false
}

variable "vpc_subnet_ids" {
  description = "Subnet IDs for Lambda function VPC config"
  type        = list(string)
  default     = []
}

variable "vpc_security_group_ids" {
  description = "Security group IDs for Lambda function VPC config"
  type        = list(string)
  default     = []
}

variable "tracing_mode" {
  description = "X-Ray tracing mode (PassThrough, Active)"
  type        = string
  default     = "PassThrough"
}

variable "api_gateway_source_arn" {
  description = "ARN of API Gateway for Lambda permission"
  type        = string
}

variable "log_group_name" {
  description = "Name of CloudWatch Logs group for Lambda function"
  type        = string
}

variable "create_function_url" {
  description = "Whether to create Lambda function URL"
  type        = bool
  default     = false
} 