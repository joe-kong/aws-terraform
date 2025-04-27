variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "billing_mode" {
  description = "Billing mode for DynamoDB table (PROVISIONED or PAY_PER_REQUEST)"
  type        = string
  default     = "PAY_PER_REQUEST"
}

variable "read_capacity" {
  description = "Read capacity for DynamoDB table when using PROVISIONED billing mode"
  type        = number
  default     = 5
}

variable "write_capacity" {
  description = "Write capacity for DynamoDB table when using PROVISIONED billing mode"
  type        = number
  default     = 5
}

variable "hash_key" {
  description = "Hash key for DynamoDB table"
  type        = string
  default     = "id"
}

variable "hash_key_type" {
  description = "Type of hash key for DynamoDB table (S, N, B)"
  type        = string
  default     = "S"
}

variable "range_key" {
  description = "Range key for DynamoDB table"
  type        = string
  default     = ""
}

variable "range_key_type" {
  description = "Type of range key for DynamoDB table (S, N, B)"
  type        = string
  default     = "S"
}

variable "attributes" {
  description = "Additional attributes for DynamoDB table"
  type = list(object({
    name = string
    type = string
  }))
  default = []
}

variable "global_secondary_indexes" {
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

variable "local_secondary_indexes" {
  description = "Local secondary indexes for DynamoDB table"
  type = list(object({
    name               = string
    range_key          = string
    projection_type    = string
    non_key_attributes = list(string)
  }))
  default = []
}

variable "ttl_enabled" {
  description = "Whether to enable TTL for DynamoDB table"
  type        = bool
  default     = false
}

variable "ttl_attribute_name" {
  description = "Attribute name for TTL"
  type        = string
  default     = "ttl"
}

variable "point_in_time_recovery_enabled" {
  description = "Whether to enable point-in-time recovery for DynamoDB table"
  type        = bool
  default     = false
}

variable "stream_enabled" {
  description = "Whether to enable DynamoDB stream"
  type        = bool
  default     = false
}

variable "stream_view_type" {
  description = "View type for DynamoDB stream (KEYS_ONLY, NEW_IMAGE, OLD_IMAGE, NEW_AND_OLD_IMAGES)"
  type        = string
  default     = "NEW_AND_OLD_IMAGES"
}

variable "autoscaling_enabled" {
  description = "Whether to enable autoscaling for DynamoDB table"
  type        = bool
  default     = false
}

variable "autoscaling_min_read_capacity" {
  description = "Minimum read capacity for autoscaling"
  type        = number
  default     = 5
}

variable "autoscaling_max_read_capacity" {
  description = "Maximum read capacity for autoscaling"
  type        = number
  default     = 100
}

variable "autoscaling_min_write_capacity" {
  description = "Minimum write capacity for autoscaling"
  type        = number
  default     = 5
}

variable "autoscaling_max_write_capacity" {
  description = "Maximum write capacity for autoscaling"
  type        = number
  default     = 100
}

variable "autoscaling_target_value" {
  description = "Target value for autoscaling (percentage of capacity)"
  type        = number
  default     = 70
} 