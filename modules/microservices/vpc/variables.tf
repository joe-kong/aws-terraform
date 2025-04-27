variable "name_prefix" {
  description = "リソース名のプレフィックス"
  type        = string
}

variable "vpc_cidr" {
  description = "VPCのCIDRブロック"
  type        = string
}

variable "availability_zones" {
  description = "利用するアベイラビリティゾーンのリスト"
  type        = list(string)
}

variable "public_subnets" {
  description = "パブリックサブネットのCIDRブロックリスト"
  type        = list(string)
}

variable "private_subnets" {
  description = "プライベートサブネットのCIDRブロックリスト"
  type        = list(string)
}

variable "enable_nat_gateway" {
  description = "NATゲートウェイを有効にするかどうか"
  type        = bool
  default     = true
}

variable "single_nat_gateway" {
  description = "すべてのプライベートサブネットに対して単一のNATゲートウェイを使用するかどうか"
  type        = bool
  default     = true
}

variable "enable_flow_log" {
  description = "VPCフローログを有効にするかどうか"
  type        = bool
  default     = false
}

variable "flow_log_destination_arn" {
  description = "VPCフローログを格納するS3バケットのARN"
  type        = string
  default     = ""
} 