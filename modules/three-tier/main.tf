locals {
  name_prefix = "${var.project_name}-${var.environment}"
}

# VPCリソース
module "vpc" {
  source = "./vpc"

  vpc_cidr            = var.vpc_cidr
  name_prefix         = local.name_prefix
  availability_zones  = var.availability_zones
  public_subnets      = var.public_subnet_cidrs
  private_app_subnets = var.private_app_subnet_cidrs
  private_db_subnets  = var.private_db_subnet_cidrs
}

# セキュリティグループ
module "security_groups" {
  source = "./security_groups"

  name_prefix = local.name_prefix
  vpc_id      = module.vpc.vpc_id
}

# ALB
module "alb" {
  source = "./alb"

  name_prefix         = local.name_prefix
  vpc_id              = module.vpc.vpc_id
  public_subnet_ids   = module.vpc.public_subnet_ids
  alb_security_group_id = module.security_groups.alb_security_group_id
  health_check_path   = var.health_check_path
}

# EC2インスタンス (Webサーバー)
module "web_tier" {
  source = "./web_tier"

  name_prefix            = local.name_prefix
  instance_type          = var.web_instance_type
  min_size               = var.web_min_size
  max_size               = var.web_max_size
  desired_capacity       = var.web_desired_capacity
  vpc_id                 = module.vpc.vpc_id
  subnet_ids             = module.vpc.private_app_subnet_ids
  security_group_id      = module.security_groups.web_security_group_id
  target_group_arns      = [module.alb.target_group_arn]
  user_data              = var.web_user_data
  key_name               = var.key_name
  ami_id                 = var.web_ami_id
}

# EC2インスタンス (アプリケーションサーバー)
module "app_tier" {
  source = "./app_tier"

  name_prefix            = local.name_prefix
  instance_type          = var.app_instance_type
  min_size               = var.app_min_size
  max_size               = var.app_max_size
  desired_capacity       = var.app_desired_capacity
  vpc_id                 = module.vpc.vpc_id
  subnet_ids             = module.vpc.private_app_subnet_ids
  security_group_id      = module.security_groups.app_security_group_id
  user_data              = var.app_user_data
  key_name               = var.key_name
  ami_id                 = var.app_ami_id
}

# RDSデータベース
module "db_tier" {
  source = "./db_tier"

  name_prefix           = local.name_prefix
  vpc_id                = module.vpc.vpc_id
  subnet_ids            = module.vpc.private_db_subnet_ids
  security_group_id     = module.security_groups.db_security_group_id
  instance_class        = var.db_instance_class
  allocated_storage     = var.db_allocated_storage
  engine                = var.db_engine
  engine_version        = var.db_engine_version
  username              = var.db_username
  password              = var.db_password
  multi_az              = var.db_multi_az
  backup_retention_period = var.db_backup_retention_period
  skip_final_snapshot   = var.db_skip_final_snapshot
} 