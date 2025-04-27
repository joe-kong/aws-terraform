output "function_id" {
  description = "ID of the Lambda function"
  value       = aws_lambda_function.this.id
}

output "function_arn" {
  description = "ARN of the Lambda function"
  value       = aws_lambda_function.this.arn
}

output "function_name" {
  description = "Name of the Lambda function"
  value       = aws_lambda_function.this.function_name
}

output "function_version" {
  description = "Version of the Lambda function"
  value       = aws_lambda_function.this.version
}

output "function_qualified_arn" {
  description = "Qualified ARN of the Lambda function"
  value       = aws_lambda_function.this.qualified_arn
}

output "invoke_arn" {
  description = "Invoke ARN of the Lambda function"
  value       = aws_lambda_function.this.invoke_arn
}

output "log_group_name" {
  description = "Name of the CloudWatch Logs group for the Lambda function"
  value       = aws_cloudwatch_log_group.this.name
}

output "log_group_arn" {
  description = "ARN of the CloudWatch Logs group for the Lambda function"
  value       = aws_cloudwatch_log_group.this.arn
}

output "function_url" {
  description = "URL of the Lambda function, if enabled"
  value       = var.create_function_url ? aws_lambda_function_url.this[0].function_url : null
} 