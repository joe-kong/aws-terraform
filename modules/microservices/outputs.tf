output "vpc_id" {
  description = "VPCのID"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "パブリックサブネットのID一覧"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "プライベートサブネットのID一覧"
  value       = module.vpc.private_subnet_ids
}

output "alb_id" {
  description = "アプリケーションロードバランサーのID"
  value       = module.alb.alb_id
}

output "alb_dns_name" {
  description = "アプリケーションロードバランサーのDNS名"
  value       = module.alb.alb_dns_name
}

output "alb_zone_id" {
  description = "アプリケーションロードバランサーのゾーンID"
  value       = module.alb.alb_zone_id
}

output "http_listener_arn" {
  description = "HTTPリスナーのARN"
  value       = module.alb.http_listener_arn
}

output "https_listener_arn" {
  description = "HTTPSリスナーのARN"
  value       = module.alb.https_listener_arn
}

output "target_group_arns" {
  description = "サービス名ごとのターゲットグループARNのマップ"
  value       = module.alb.target_group_arns
}

output "ecs_cluster_id" {
  description = "ECSクラスターのID"
  value       = module.ecs_cluster.cluster_id
}

output "ecs_cluster_name" {
  description = "ECSクラスターの名前"
  value       = module.ecs_cluster.cluster_name
}

output "ecs_cluster_arn" {
  description = "ECSクラスターのARN"
  value       = module.ecs_cluster.cluster_arn
}

output "service_discovery_namespace_id" {
  description = "サービスディスカバリー名前空間のID"
  value       = module.service_discovery.namespace_id
}

output "service_discovery_namespace_arn" {
  description = "サービスディスカバリー名前空間のARN"
  value       = module.service_discovery.namespace_arn
}

output "service_discovery_namespace_name" {
  description = "サービスディスカバリー名前空間の名前"
  value       = module.service_discovery.namespace_name
}

output "services" {
  description = "サービス名ごとのサービス詳細のマップ"
  value = {
    for name, svc in module.ecs_services : name => {
      service_id   = svc.service_id
      service_name = svc.service_name
      service_arn  = svc.service_arn
      task_definition_arn = svc.task_definition_arn
      service_discovery_service_arn = svc.service_discovery_service_arn
    }
  }
}

output "security_groups" {
  description = "セキュリティグループIDのマップ"
  value = {
    alb      = module.security_groups.alb_security_group_id
    services = module.security_groups.services_security_group_id
  }
} 