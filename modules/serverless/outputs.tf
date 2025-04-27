output "vpc_id" {
  description = "ID of the VPC"
  value       = var.create_vpc ? module.vpc[0].vpc_id : null
}

output "api_gateway_id" {
  description = "ID of the API Gateway"
  value       = module.api_gateway.api_id
}

output "api_gateway_endpoint" {
  description = "Endpoint URL of the API Gateway"
  value       = module.api_gateway.api_endpoint
}

output "api_gateway_execution_arn" {
  description = "Execution ARN of the API Gateway"
  value       = module.api_gateway.api_gateway_execution_arn
}

output "api_gateway_stage_name" {
  description = "Stage name of the API Gateway deployment"
  value       = var.environment
}

output "api_gateway_invoke_url" {
  description = "Invoke URL of the API Gateway stage"
  value       = module.api_gateway.api_invoke_url
}

output "api_gateway_domain_name_url" {
  description = "Custom domain URL of the API Gateway, if configured"
  value       = module.api_gateway.domain_name_url
}

output "lambda_function_name" {
  description = "Name of the Lambda function"
  value       = module.lambda.function_name
}

output "lambda_function_arn" {
  description = "ARN of the Lambda function"
  value       = module.lambda.function_arn
}

output "lambda_function_invoke_arn" {
  description = "Invoke ARN of the Lambda function"
  value       = module.lambda.invoke_arn
}

output "lambda_function_version" {
  description = "Version of the Lambda function"
  value       = module.lambda.function_version
}

output "lambda_function_qualified_arn" {
  description = "Qualified ARN of the Lambda function"
  value       = module.lambda.function_qualified_arn
}

output "lambda_role_arn" {
  description = "ARN of the IAM role for Lambda function"
  value       = module.iam.lambda_execution_role_arn
}

output "lambda_role_name" {
  description = "Name of the IAM role for Lambda function"
  value       = module.iam.lambda_execution_role_name
}

output "dynamodb_table_id" {
  description = "ID of the DynamoDB table"
  value       = module.dynamodb.table_id
}

output "dynamodb_table_arn" {
  description = "ARN of the DynamoDB table"
  value       = module.dynamodb.table_arn
}

output "dynamodb_table_name" {
  description = "Name of the DynamoDB table"
  value       = module.dynamodb.table_name
}

output "dynamodb_table_hash_key" {
  description = "Hash key of the DynamoDB table"
  value       = module.dynamodb.table_hash_key
}

output "dynamodb_table_range_key" {
  description = "Range key of the DynamoDB table, if configured"
  value       = module.dynamodb.table_range_key
}

output "dynamodb_table_stream_arn" {
  description = "ARN of the DynamoDB table stream, if enabled"
  value       = module.dynamodb.table_stream_arn
} 