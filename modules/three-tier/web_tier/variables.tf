variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "ami_id" {
  description = "AMI ID to use for instances"
  type        = string
  default     = ""
}

variable "key_name" {
  description = "SSH key name"
  type        = string
  default     = ""
}

variable "security_group_id" {
  description = "Security group ID for instances"
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs where instances will be launched"
  type        = list(string)
}

variable "min_size" {
  description = "Minimum size of auto scaling group"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum size of auto scaling group"
  type        = number
  default     = 3
}

variable "desired_capacity" {
  description = "Desired capacity of auto scaling group"
  type        = number
  default     = 2
}

variable "target_group_arns" {
  description = "ARNs of target groups for ALB"
  type        = list(string)
  default     = []
}

variable "user_data" {
  description = "User data script for instances"
  type        = string
  default     = ""
}

variable "instance_profile_name" {
  description = "IAM instance profile name"
  type        = string
  default     = ""
}

variable "detailed_monitoring" {
  description = "Whether to enable detailed monitoring"
  type        = bool
  default     = false
}

variable "root_volume_size" {
  description = "Size of root volume in GB"
  type        = number
  default     = 20
} 