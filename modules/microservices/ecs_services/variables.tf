variable "name_prefix" {
  description = "プロジェクト名と環境名を組み合わせた接頭辞"
  type        = string
}

variable "service_name" {
  description = "ECSサービスの名前"
  type        = string
}

variable "cluster_id" {
  description = "ECSクラスターのID"
  type        = string
}

variable "vpc_id" {
  description = "VPCのID"
  type        = string
}

variable "subnet_ids" {
  description = "サービスを配置するサブネットのID一覧"
  type        = list(string)
}

variable "security_group_id" {
  description = "サービスに関連付けるセキュリティグループのID"
  type        = string
}

variable "container_port" {
  description = "コンテナのポート番号"
  type        = number
}

variable "container_image" {
  description = "コンテナイメージのURI"
  type        = string
}

variable "cpu" {
  description = "タスク定義に割り当てるCPUユニット"
  type        = number
  default     = 256
}

variable "memory" {
  description = "タスク定義に割り当てるメモリ (MiB)"
  type        = number
  default     = 512
}

variable "desired_count" {
  description = "実行するタスクの数"
  type        = number
  default     = 1
}

variable "max_capacity" {
  description = "Auto Scalingの最大タスク数"
  type        = number
  default     = 5
}

variable "min_capacity" {
  description = "Auto Scalingの最小タスク数"
  type        = number
  default     = 1
}

variable "health_check_path" {
  description = "ヘルスチェックのパス"
  type        = string
  default     = "/"
}

variable "health_check_grace_period" {
  description = "タスク起動後のヘルスチェック猶予期間（秒）"
  type        = number
  default     = 60
}

variable "deployment_maximum_percent" {
  description = "デプロイ中の最大タスク実行率（%）"
  type        = number
  default     = 200
}

variable "deployment_minimum_percent" {
  description = "デプロイ中の最小タスク実行率（%）"
  type        = number
  default     = 100
}

variable "environment_variables" {
  description = "コンテナに設定する環境変数のマップ"
  type        = map(string)
  default     = {}
}

variable "secrets" {
  description = "コンテナに設定するシークレット情報のマップ（キー名と ARN の組み合わせ）"
  type        = map(string)
  default     = {}
}

variable "alb_target_group_arn" {
  description = "サービスに関連付けるALBターゲットグループのARN（空文字列の場合は関連付けなし）"
  type        = string
  default     = ""
}

variable "create_target_group" {
  description = "ALBターゲットグループを作成するかどうか"
  type        = bool
  default     = true
}

variable "service_discovery_namespace_id" {
  description = "Service DiscoveryのネームスペースID"
  type        = string
}

variable "enable_service_discovery" {
  description = "Service Discoveryを有効にするかどうか"
  type        = bool
  default     = false
}

variable "service_discovery_dns_ttl" {
  description = "Service DiscoveryのDNS TTL（秒）"
  type        = number
  default     = 10
}

variable "service_discovery_routing_policy" {
  description = "Service Discoveryのルーティングポリシー"
  type        = string
  default     = "MULTIVALUE"
  validation {
    condition     = contains(["MULTIVALUE", "WEIGHTED"], var.service_discovery_routing_policy)
    error_message = "ルーティングポリシーは「MULTIVALUE」または「WEIGHTED」である必要があります。"
  }
}

variable "task_role_arn" {
  description = "ECSタスクに関連付けるIAMロールのARN"
  type        = string
  default     = ""
}

variable "execution_role_arn" {
  description = "ECSタスク実行に関連付けるIAMロールのARN"
  type        = string
  default     = ""
}

variable "enable_execute_command" {
  description = "ECS Execを有効にするかどうか（コンテナへのSSH接続）"
  type        = bool
  default     = false
} 