locals {
  source_code_hash = var.source_path != null ? filebase64sha256(var.source_path) : null
}

# Lambda関数
resource "aws_lambda_function" "this" {
  function_name    = "${var.name_prefix}-function"
  handler          = var.handler
  runtime          = var.runtime
  timeout          = var.timeout
  memory_size      = var.memory_size
  role             = var.execution_role_arn

  # ソースコードパスが指定されている場合
  filename         = var.source_path != null ? var.source_path : null
  source_code_hash = local.source_code_hash

  # ソースコードパスが指定されていない場合はダミーコードを使用
  dynamic "environment" {
    for_each = length(var.environment_variables) > 0 ? [1] : []
    content {
      variables = var.environment_variables
    }
  }

  # VPC設定（VPC内で実行する場合）
  dynamic "vpc_config" {
    for_each = var.create_in_vpc && length(var.vpc_subnet_ids) > 0 ? [1] : []
    content {
      subnet_ids         = var.vpc_subnet_ids
      security_group_ids = var.vpc_security_group_ids
    }
  }

  # X-Ray tracing設定
  tracing_config {
    mode = var.tracing_mode
  }

  tags = {
    Name = "${var.name_prefix}-function"
  }

  depends_on = [aws_cloudwatch_log_group.this]
}

# Lambda Permissionの設定（APIゲートウェイからの呼び出し許可）
resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${var.api_gateway_source_arn}/*/*"
}

# CloudWatch Logsグループ
resource "aws_cloudwatch_log_group" "this" {
  name              = var.log_group_name
  retention_in_days = 30

  tags = {
    Name = "${var.name_prefix}-function-logs"
  }
}

# 関数URLの設定（必要な場合）
resource "aws_lambda_function_url" "this" {
  count              = var.create_function_url ? 1 : 0
  function_name      = aws_lambda_function.this.function_name
  authorization_type = "NONE"

  cors {
    allow_credentials = true
    allow_origins     = ["*"]
    allow_methods     = ["*"]
    allow_headers     = ["date", "keep-alive"]
    expose_headers    = ["keep-alive", "date"]
    max_age           = 86400
  }
} 