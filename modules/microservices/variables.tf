variable "project_name" {
  description = "Project name used for resource naming and tagging"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
}

# VPC関連の変数
variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "List of availability zones to use"
  type        = list(string)
  default     = ["ap-northeast-1a", "ap-northeast-1c", "ap-northeast-1d"]
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]
}

variable "enable_nat_gateway" {
  description = "Whether to enable NAT Gateway"
  type        = bool
  default     = true
}

variable "single_nat_gateway" {
  description = "Whether to use a single NAT Gateway"
  type        = bool
  default     = true
}

# セキュリティグループ関連の変数
variable "alb_ingress_cidr_blocks" {
  description = "CIDR blocks for ALB ingress"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "app_ports" {
  description = "Application ports for services"
  type        = list(number)
  default     = [80, 8080, 8443]
}

# ALB関連の変数
variable "health_check_path" {
  description = "Health check path for ALB target groups"
  type        = string
  default     = "/"
}

variable "ssl_certificate_arn" {
  description = "ARN of SSL certificate for HTTPS"
  type        = string
  default     = ""
}

variable "enable_https" {
  description = "Whether to enable HTTPS"
  type        = bool
  default     = false
}

variable "enable_http_to_https_redirect" {
  description = "Whether to redirect HTTP to HTTPS"
  type        = bool
  default     = false
}

# サービスディスカバリ
variable "service_discovery_namespace" {
  description = "Namespace for service discovery"
  type        = string
  default     = "microservices.local"
}

# タグ
variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

# ECSサービス定義
variable "services" {
  description = "Map of ECS services to create"
  type = map(object({
    container_port             = number
    container_image            = string
    cpu                        = number
    memory                     = number
    desired_count              = number
    max_capacity               = number
    min_capacity               = number
    health_check_path          = string
    health_check_grace_period  = number
    deployment_maximum_percent = number
    deployment_minimum_percent = number
    environment_variables      = map(string)
    secrets                    = map(string)
    create_alb_target_group    = bool
    enable_service_discovery   = bool
    service_discovery_dns_ttl  = number
    service_discovery_routing_policy = string
    task_role_arn              = string
    execution_role_arn         = string
    enable_execute_command     = bool
    listener_rules = list(object({
      path_pattern = string
      host_header  = string
      priority     = number
    }))
  }))
  default = {}
} 