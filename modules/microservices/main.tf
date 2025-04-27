locals {
  name_prefix = "${var.project_name}-${var.environment}"
}

# VPCリソース
module "vpc" {
  source = "./vpc"

  name_prefix         = local.name_prefix
  vpc_cidr            = var.vpc_cidr
  availability_zones  = var.availability_zones
  public_subnets      = var.public_subnet_cidrs
  private_subnets     = var.private_subnet_cidrs
  enable_nat_gateway  = var.enable_nat_gateway
  single_nat_gateway  = var.single_nat_gateway
}

# セキュリティグループ
module "security_groups" {
  source = "./security_groups"

  name_prefix                 = local.name_prefix
  vpc_id                      = module.vpc.vpc_id
  alb_ingress_cidr_blocks     = var.alb_ingress_cidr_blocks
  app_ports                   = var.app_ports
  service_discovery_namespace = var.service_discovery_namespace
}

# ALB
module "alb" {
  source = "./alb"

  name_prefix           = local.name_prefix
  vpc_id                = module.vpc.vpc_id
  subnet_ids            = module.vpc.public_subnet_ids
  security_group_ids    = [module.security_groups.alb_security_group_id]
  health_check_path     = var.health_check_path
  ssl_certificate_arn   = var.ssl_certificate_arn
  enable_https          = var.enable_https
  enable_http_to_https_redirect = var.enable_http_to_https_redirect
}

# ECS Cluster
module "ecs_cluster" {
  source = "./ecs_cluster"

  name_prefix             = local.name_prefix
  enable_container_insights = true
  log_retention_days      = 30
  tags                    = var.tags
}

# Service Discovery
module "service_discovery" {
  source = "./service_discovery"

  name_prefix = local.name_prefix
  vpc_id      = module.vpc.vpc_id
  namespace   = var.service_discovery_namespace
}

# ECS Services
module "ecs_services" {
  source = "./ecs_services"

  for_each = var.services

  name_prefix                = local.name_prefix
  service_name               = each.key
  cluster_id                 = module.ecs_cluster.cluster_id
  vpc_id                     = module.vpc.vpc_id
  subnet_ids                 = module.vpc.private_subnet_ids
  security_group_id          = module.security_groups.services_security_group_id
  container_port             = each.value.container_port
  container_image            = each.value.container_image
  cpu                        = each.value.cpu
  memory                     = each.value.memory
  desired_count              = each.value.desired_count
  max_capacity               = each.value.max_capacity
  min_capacity               = each.value.min_capacity
  health_check_path          = each.value.health_check_path
  health_check_grace_period  = each.value.health_check_grace_period
  deployment_maximum_percent = each.value.deployment_maximum_percent
  deployment_minimum_percent = each.value.deployment_minimum_percent
  environment_variables      = each.value.environment_variables
  secrets                    = each.value.secrets
  alb_target_group_arn       = each.value.create_alb_target_group ? module.alb.target_group_arns[each.key] : ""
  create_target_group        = each.value.create_alb_target_group
  service_discovery_namespace_id = module.service_discovery.namespace_id
  enable_service_discovery   = each.value.enable_service_discovery
  service_discovery_dns_ttl  = each.value.service_discovery_dns_ttl
  service_discovery_routing_policy = each.value.service_discovery_routing_policy
  task_role_arn              = each.value.task_role_arn
  execution_role_arn         = each.value.execution_role_arn
  enable_execute_command     = each.value.enable_execute_command
}

# ALBリスナールール
module "alb_listener_rules" {
  source = "./alb_listener_rules"

  for_each = {
    for name, service in var.services : name => service
    if service.create_alb_target_group && length(service.listener_rules) > 0
  }

  name_prefix      = local.name_prefix
  service_name     = each.key
  listener_arn     = var.enable_https ? module.alb.https_listener_arn : module.alb.http_listener_arn
  target_group_arn = module.alb.target_group_arns[each.key]
  listener_rules   = each.value.listener_rules
  priority_start   = 100 # ルールの優先度を設定
} 