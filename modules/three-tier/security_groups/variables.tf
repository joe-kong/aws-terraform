variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where security groups will be created"
  type        = string
}

variable "app_port" {
  description = "Port for application servers"
  type        = number
  default     = 8080
}

variable "db_port" {
  description = "Port for database"
  type        = number
  default     = 3306
}

variable "trusted_cidrs" {
  description = "CIDR blocks for SSH access"
  type        = list(string)
  default     = ["10.0.0.0/8"]
} 