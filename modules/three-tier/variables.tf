variable "project_name" {
  description = "Project name used for resource naming and tagging"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "List of availability zones to use"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_app_subnet_cidrs" {
  description = "CIDR blocks for private application subnets"
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]
}

variable "private_db_subnet_cidrs" {
  description = "CIDR blocks for private database subnets"
  type        = list(string)
  default     = ["10.0.21.0/24", "10.0.22.0/24", "10.0.23.0/24"]
}

variable "health_check_path" {
  description = "Health check path for ALB target group"
  type        = string
  default     = "/"
}

# Web層の変数
variable "web_instance_type" {
  description = "EC2 instance type for web tier"
  type        = string
  default     = "t3.micro"
}

variable "web_min_size" {
  description = "Minimum size of web tier auto scaling group"
  type        = number
  default     = 1
}

variable "web_max_size" {
  description = "Maximum size of web tier auto scaling group"
  type        = number
  default     = 3
}

variable "web_desired_capacity" {
  description = "Desired capacity of web tier auto scaling group"
  type        = number
  default     = 2
}

variable "web_user_data" {
  description = "User data script for web tier instances"
  type        = string
  default     = ""
}

variable "web_ami_id" {
  description = "AMI ID for web tier instances"
  type        = string
  default     = ""
}

# アプリケーション層の変数
variable "app_instance_type" {
  description = "EC2 instance type for app tier"
  type        = string
  default     = "t3.small"
}

variable "app_min_size" {
  description = "Minimum size of app tier auto scaling group"
  type        = number
  default     = 1
}

variable "app_max_size" {
  description = "Maximum size of app tier auto scaling group"
  type        = number
  default     = 3
}

variable "app_desired_capacity" {
  description = "Desired capacity of app tier auto scaling group"
  type        = number
  default     = 2
}

variable "app_user_data" {
  description = "User data script for app tier instances"
  type        = string
  default     = ""
}

variable "app_ami_id" {
  description = "AMI ID for app tier instances"
  type        = string
  default     = ""
}

variable "key_name" {
  description = "SSH key name for EC2 instances"
  type        = string
  default     = ""
}

# データベース層の変数
variable "db_instance_class" {
  description = "Instance class for RDS database"
  type        = string
  default     = "db.t3.small"
}

variable "db_allocated_storage" {
  description = "Allocated storage for RDS database (in GB)"
  type        = number
  default     = 20
}

variable "db_engine" {
  description = "Database engine for RDS"
  type        = string
  default     = "mysql"
}

variable "db_engine_version" {
  description = "Database engine version for RDS"
  type        = string
  default     = "8.0"
}

variable "db_username" {
  description = "Master username for RDS database"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Master password for RDS database"
  type        = string
  sensitive   = true
}

variable "db_multi_az" {
  description = "Whether to deploy RDS in multiple availability zones"
  type        = bool
  default     = false
}

variable "db_backup_retention_period" {
  description = "Number of days to retain RDS backups"
  type        = number
  default     = 7
}

variable "db_skip_final_snapshot" {
  description = "Whether to skip final snapshot when destroying RDS instance"
  type        = bool
  default     = true
} 