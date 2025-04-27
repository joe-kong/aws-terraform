# API Gateway V2（HTTPタイプ）
resource "aws_apigatewayv2_api" "this" {
  name          = "${var.name_prefix}-api"
  protocol_type = "HTTP"
  description   = var.description

  cors_configuration {
    allow_origins = var.cors_allow_origins
    allow_methods = var.cors_allow_methods
    allow_headers = var.cors_allow_headers
    max_age       = var.cors_max_age
  }

  tags = {
    Name = "${var.name_prefix}-api"
  }
}

# API Gatewayステージ
resource "aws_apigatewayv2_stage" "this" {
  api_id      = aws_apigatewayv2_api.this.id
  name        = var.stage_name
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_logs.arn
    format = jsonencode({
      requestId      = "$context.requestId"
      ip             = "$context.identity.sourceIp"
      requestTime    = "$context.requestTime"
      httpMethod     = "$context.httpMethod"
      routeKey       = "$context.routeKey"
      status         = "$context.status"
      protocol       = "$context.protocol"
      responseLength = "$context.responseLength"
      integrationError = "$context.integrationErrorMessage"
      integrationLatency = "$context.integrationLatency"
      responseLatency = "$context.responseLatency"
    })
  }

  default_route_settings {
    throttling_burst_limit = var.throttling_burst_limit
    throttling_rate_limit  = var.throttling_rate_limit
    detailed_metrics_enabled = var.metrics_enabled
  }

  stage_variables = {
    environment = var.stage_name
  }

  tags = {
    Name = "${var.name_prefix}-stage-${var.stage_name}"
  }

  depends_on = [aws_cloudwatch_log_group.api_logs]
}

# CloudWatch Logs for API Gateway
resource "aws_cloudwatch_log_group" "api_logs" {
  name              = "/aws/apigateway/${var.name_prefix}-api-${var.stage_name}"
  retention_in_days = 7

  tags = {
    Name = "${var.name_prefix}-api-logs"
  }
}

# カスタムドメイン名（設定されている場合）
resource "aws_apigatewayv2_domain_name" "this" {
  count = var.domain_name != "" && var.certificate_arn != "" ? 1 : 0

  domain_name = var.domain_name

  domain_name_configuration {
    certificate_arn = var.certificate_arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }

  tags = {
    Name = "${var.name_prefix}-domain"
  }
}

# カスタムドメイン名とAPIのマッピング
resource "aws_apigatewayv2_api_mapping" "this" {
  count = var.domain_name != "" && var.certificate_arn != "" ? 1 : 0

  api_id      = aws_apigatewayv2_api.this.id
  domain_name = aws_apigatewayv2_domain_name.this[0].id
  stage       = aws_apigatewayv2_stage.this.id
} 