variable "name_prefix" {
  description = "リソース名のプレフィックス"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "alb_ingress_cidr_blocks" {
  description = "ALBへのインバウンドトラフィックを許可するCIDRブロックのリスト"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "app_ports" {
  description = "サービスへのトラフィックに使用されるポートのリスト"
  type        = list(number)
  default     = [80, 8080, 8443]
}

variable "service_discovery_namespace" {
  description = "サービスディスカバリの名前空間"
  type        = string
  default     = "microservices.local"
} 