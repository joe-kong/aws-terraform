# Lambda統合
resource "aws_apigatewayv2_integration" "lambda" {
  api_id             = var.api_id
  integration_type   = "AWS_PROXY"
  integration_uri    = var.lambda_invoke_arn
  integration_method = "POST"
  payload_format_version = "2.0"
  timeout_milliseconds = 30000
}

# ルートの設定
resource "aws_apigatewayv2_route" "routes" {
  for_each = { for idx, route in var.route_configs : "${route.method}-${route.path}" => route }

  api_id             = var.api_id
  route_key          = "${each.value.method} ${each.value.path}"
  target             = "integrations/${aws_apigatewayv2_integration.lambda.id}"
  operation_name     = each.value.operation_name
  authorization_type = "NONE"
} 