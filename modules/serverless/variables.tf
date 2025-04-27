variable "project_name" {
  description = "Project name used for resource naming and tagging"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
}

# VPC関連の変数
variable "create_vpc" {
  description = "Whether to create a VPC for Lambda functions"
  type        = bool
  default     = true
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "List of availability zones to use"
  type        = list(string)
  default     = ["ap-northeast-1a", "ap-northeast-1c"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "existing_vpc_subnet_ids" {
  description = "List of existing subnet IDs if not creating a VPC"
  type        = list(string)
  default     = []
}

variable "existing_security_group_ids" {
  description = "List of existing security group IDs if not creating a VPC"
  type        = list(string)
  default     = []
}

# IAM関連の変数
variable "logs_retention_days" {
  description = "Number of days to retain CloudWatch logs"
  type        = number
  default     = 30
}

# API Gateway関連の変数
variable "api_gateway_description" {
  description = "Description for the API Gateway"
  type        = string
  default     = "API Gateway for Serverless Application"
}

variable "api_gateway_logging_level" {
  description = "Logging level for API Gateway (OFF, ERROR, INFO)"
  type        = string
  default     = "INFO"
}

variable "api_gateway_metrics_enabled" {
  description = "Whether to enable metrics for API Gateway"
  type        = bool
  default     = true
}

variable "api_gateway_xray_tracing_enabled" {
  description = "Whether to enable X-Ray tracing for API Gateway"
  type        = bool
  default     = false
}

variable "api_gateway_throttling_rate_limit" {
  description = "Rate limit for API Gateway throttling"
  type        = number
  default     = 10000
}

variable "api_gateway_throttling_burst_limit" {
  description = "Burst limit for API Gateway throttling"
  type        = number
  default     = 5000
}

variable "api_gateway_cors_allow_origins" {
  description = "List of allowed origins for CORS"
  type        = list(string)
  default     = ["*"]
}

variable "api_gateway_cors_allow_methods" {
  description = "List of allowed methods for CORS"
  type        = list(string)
  default     = ["GET", "POST", "PUT", "DELETE", "OPTIONS"]
}

variable "api_gateway_cors_allow_headers" {
  description = "List of allowed headers for CORS"
  type        = list(string)
  default     = ["Content-Type", "Authorization", "X-Amz-Date", "X-Api-Key", "X-Amz-Security-Token"]
}

variable "api_gateway_cors_max_age" {
  description = "Max age for CORS in seconds"
  type        = number
  default     = 7200
}

variable "api_gateway_domain_name" {
  description = "Custom domain name for API Gateway"
  type        = string
  default     = ""
}

variable "api_gateway_certificate_arn" {
  description = "ACM certificate ARN for API Gateway custom domain"
  type        = string
  default     = ""
}

variable "api_route_configs" {
  description = "List of route configurations for API Gateway"
  type = list(object({
    path        = string
    method      = string
    operation_name = string
  }))
  default = [
    {
      path           = "/items"
      method         = "GET"
      operation_name = "GetItems"
    },
    {
      path           = "/items"
      method         = "POST"
      operation_name = "CreateItem"
    },
    {
      path           = "/items/{id}"
      method         = "GET"
      operation_name = "GetItem"
    },
    {
      path           = "/items/{id}"
      method         = "PUT"
      operation_name = "UpdateItem"
    },
    {
      path           = "/items/{id}"
      method         = "DELETE"
      operation_name = "DeleteItem"
    }
  ]
}

# Lambda関連の変数
variable "lambda_handler" {
  description = "Handler for Lambda function"
  type        = string
  default     = "index.handler"
}

variable "lambda_runtime" {
  description = "Runtime for Lambda function"
  type        = string
  default     = "nodejs18.x"
}

variable "lambda_timeout" {
  description = "Timeout for Lambda function in seconds"
  type        = number
  default     = 30
}

variable "lambda_memory_size" {
  description = "Memory size for Lambda function in MB"
  type        = number
  default     = 128
}

variable "lambda_source_path" {
  description = "Path to source code for Lambda function"
  type        = string
  default     = null
}

variable "lambda_environment_variables" {
  description = "Environment variables for Lambda function"
  type        = map(string)
  default     = {}
}

variable "lambda_create_in_vpc" {
  description = "Whether to create Lambda function in VPC"
  type        = bool
  default     = false
}

variable "lambda_tracing_mode" {
  description = "X-Ray tracing mode for Lambda function (PassThrough, Active)"
  type        = string
  default     = "PassThrough"
}

# DynamoDB関連の変数
variable "dynamodb_billing_mode" {
  description = "Billing mode for DynamoDB table (PROVISIONED or PAY_PER_REQUEST)"
  type        = string
  default     = "PAY_PER_REQUEST"
}

variable "dynamodb_read_capacity" {
  description = "Read capacity for DynamoDB table when using PROVISIONED billing mode"
  type        = number
  default     = 5
}

variable "dynamodb_write_capacity" {
  description = "Write capacity for DynamoDB table when using PROVISIONED billing mode"
  type        = number
  default     = 5
}

variable "dynamodb_hash_key" {
  description = "Hash key for DynamoDB table"
  type        = string
  default     = "id"
}

variable "dynamodb_hash_key_type" {
  description = "Type of hash key for DynamoDB table (S, N, B)"
  type        = string
  default     = "S"
}

variable "dynamodb_range_key" {
  description = "Range key for DynamoDB table"
  type        = string
  default     = ""
}

variable "dynamodb_range_key_type" {
  description = "Type of range key for DynamoDB table (S, N, B)"
  type        = string
  default     = "S"
}

variable "dynamodb_attributes" {
  description = "Additional attributes for DynamoDB table"
  type = list(object({
    name = string
    type = string
  }))
  default = []
}

variable "dynamodb_global_secondary_indexes" {
  description = "Global secondary indexes for DynamoDB table"
  type = list(object({
    name               = string
    hash_key           = string
    range_key          = string
    projection_type    = string
    non_key_attributes = list(string)
    read_capacity      = number
    write_capacity     = number
  }))
  default = []
}

variable "dynamodb_local_secondary_indexes" {
  description = "Local secondary indexes for DynamoDB table"
  type = list(object({
    name               = string
    range_key          = string
    projection_type    = string
    non_key_attributes = list(string)
  }))
  default = []
}

variable "dynamodb_ttl_enabled" {
  description = "Whether to enable TTL for DynamoDB table"
  type        = bool
  default     = false
}

variable "dynamodb_ttl_attribute_name" {
  description = "Attribute name for TTL"
  type        = string
  default     = "ttl"
}

variable "dynamodb_point_in_time_recovery_enabled" {
  description = "Whether to enable point-in-time recovery for DynamoDB table"
  type        = bool
  default     = false
}

variable "dynamodb_stream_enabled" {
  description = "Whether to enable DynamoDB stream"
  type        = bool
  default     = false
}

variable "dynamodb_stream_view_type" {
  description = "View type for DynamoDB stream (KEYS_ONLY, NEW_IMAGE, OLD_IMAGE, NEW_AND_OLD_IMAGES)"
  type        = string
  default     = "NEW_AND_OLD_IMAGES"
}

variable "dynamodb_autoscaling_enabled" {
  description = "Whether to enable autoscaling for DynamoDB table"
  type        = bool
  default     = false
}

variable "dynamodb_autoscaling_min_read_capacity" {
  description = "Minimum read capacity for autoscaling"
  type        = number
  default     = 5
}

variable "dynamodb_autoscaling_max_read_capacity" {
  description = "Maximum read capacity for autoscaling"
  type        = number
  default     = 100
}

variable "dynamodb_autoscaling_min_write_capacity" {
  description = "Minimum write capacity for autoscaling"
  type        = number
  default     = 5
}

variable "dynamodb_autoscaling_max_write_capacity" {
  description = "Maximum write capacity for autoscaling"
  type        = number
  default     = 100
}

variable "dynamodb_autoscaling_target_value" {
  description = "Target value for autoscaling (percentage of capacity)"
  type        = number
  default     = 70
} 