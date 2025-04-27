variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}

variable "availability_zones" {
  description = "List of availability zones to use"
  type        = list(string)
}

variable "public_subnets" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_app_subnets" {
  description = "CIDR blocks for private application subnets"
  type        = list(string)
}

variable "private_db_subnets" {
  description = "CIDR blocks for private database subnets"
  type        = list(string)
}

variable "single_nat_gateway" {
  description = "Whether to use a single NAT gateway for all private subnets"
  type        = bool
  default     = true
}

variable "enable_flow_log" {
  description = "Whether to enable VPC flow logs"
  type        = bool
  default     = false
}

variable "flow_log_destination_arn" {
  description = "ARN of the S3 bucket to store VPC flow logs"
  type        = string
  default     = ""
} 