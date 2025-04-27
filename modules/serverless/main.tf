locals {
  name_prefix = "${var.project_name}-${var.environment}"
}

# VPCリソース（Lambda関数用）
module "vpc" {
  source = "./vpc"
  count  = var.create_vpc ? 1 : 0

  name_prefix        = local.name_prefix
  vpc_cidr           = var.vpc_cidr
  availability_zones = var.availability_zones
  private_subnets    = var.private_subnet_cidrs
  public_subnets     = var.public_subnet_cidrs
}

# IAMリソース
module "iam" {
  source = "./iam"

  name_prefix = local.name_prefix
  logs_retention_days = var.logs_retention_days
}

# APIゲートウェイ
module "api_gateway" {
  source = "./api_gateway"

  name_prefix                  = local.name_prefix
  description                  = var.api_gateway_description
  stage_name                   = var.environment
  logging_level                = var.api_gateway_logging_level
  metrics_enabled              = var.api_gateway_metrics_enabled
  xray_tracing_enabled         = var.api_gateway_xray_tracing_enabled
  throttling_rate_limit        = var.api_gateway_throttling_rate_limit
  throttling_burst_limit       = var.api_gateway_throttling_burst_limit
  cors_allow_origins           = var.api_gateway_cors_allow_origins
  cors_allow_methods           = var.api_gateway_cors_allow_methods
  cors_allow_headers           = var.api_gateway_cors_allow_headers
  cors_max_age                 = var.api_gateway_cors_max_age
  domain_name                  = var.api_gateway_domain_name
  certificate_arn              = var.api_gateway_certificate_arn
  depends_on                   = [module.iam]
}

# Lambda関数
module "lambda" {
  source = "./lambda"

  name_prefix            = local.name_prefix
  handler                = var.lambda_handler
  runtime                = var.lambda_runtime
  timeout                = var.lambda_timeout
  memory_size            = var.lambda_memory_size
  source_path            = var.lambda_source_path
  environment_variables  = var.lambda_environment_variables
  vpc_subnet_ids         = var.create_vpc ? module.vpc[0].private_subnet_ids : var.existing_vpc_subnet_ids
  vpc_security_group_ids = var.create_vpc ? [module.vpc[0].lambda_security_group_id] : var.existing_security_group_ids
  execution_role_arn     = module.iam.lambda_execution_role_arn
  create_in_vpc          = var.lambda_create_in_vpc
  tracing_mode           = var.lambda_tracing_mode
  api_gateway_source_arn = module.api_gateway.api_gateway_execution_arn
  log_group_name         = "/aws/lambda/${local.name_prefix}-function"
}

# Lambda関数とAPIゲートウェイの統合
module "api_lambda_integration" {
  source = "./api_lambda_integration"

  name_prefix        = local.name_prefix
  api_id             = module.api_gateway.api_id
  api_execution_arn  = module.api_gateway.api_gateway_execution_arn
  lambda_function_id = module.lambda.function_id
  lambda_invoke_arn  = module.lambda.invoke_arn
  route_configs      = var.api_route_configs
}

# DynamoDB
module "dynamodb" {
  source = "./dynamodb"

  name_prefix         = local.name_prefix
  billing_mode        = var.dynamodb_billing_mode
  read_capacity       = var.dynamodb_read_capacity
  write_capacity      = var.dynamodb_write_capacity
  hash_key            = var.dynamodb_hash_key
  hash_key_type       = var.dynamodb_hash_key_type
  range_key           = var.dynamodb_range_key
  range_key_type      = var.dynamodb_range_key_type
  attributes          = var.dynamodb_attributes
  global_secondary_indexes = var.dynamodb_global_secondary_indexes
  local_secondary_indexes  = var.dynamodb_local_secondary_indexes
  ttl_enabled         = var.dynamodb_ttl_enabled
  ttl_attribute_name  = var.dynamodb_ttl_attribute_name
  point_in_time_recovery_enabled = var.dynamodb_point_in_time_recovery_enabled
  stream_enabled      = var.dynamodb_stream_enabled
  stream_view_type    = var.dynamodb_stream_view_type
  autoscaling_enabled = var.dynamodb_autoscaling_enabled
  autoscaling_min_read_capacity  = var.dynamodb_autoscaling_min_read_capacity
  autoscaling_max_read_capacity  = var.dynamodb_autoscaling_max_read_capacity
  autoscaling_min_write_capacity = var.dynamodb_autoscaling_min_write_capacity
  autoscaling_max_write_capacity = var.dynamodb_autoscaling_max_write_capacity
  autoscaling_target_value       = var.dynamodb_autoscaling_target_value
} 