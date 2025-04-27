output "integration_id" {
  description = "ID of the API Gateway integration"
  value       = aws_apigatewayv2_integration.lambda.id
}

output "route_ids" {
  description = "Map of route IDs by route key"
  value       = { for k, v in aws_apigatewayv2_route.routes : k => v.id }
} 