output "alb_id" {
  description = "ALBのID"
  value       = aws_lb.this.id
}

output "alb_arn" {
  description = "ALBのARN"
  value       = aws_lb.this.arn
}

output "alb_dns_name" {
  description = "ALBのDNS名"
  value       = aws_lb.this.dns_name
}

output "alb_zone_id" {
  description = "ALBのゾーンID"
  value       = aws_lb.this.zone_id
}

output "target_group_arns" {
  description = "ターゲットグループのARNマップ（サービス名をキーとする）"
  value       = { for k, v in aws_lb_target_group.this : k => v.arn }
}

output "target_group_ids" {
  description = "ターゲットグループのIDマップ（サービス名をキーとする）"
  value       = { for k, v in aws_lb_target_group.this : k => v.id }
}

output "http_listener_arn" {
  description = "HTTPリスナーのARN"
  value       = aws_lb_listener.http.arn
}

output "https_listener_arn" {
  description = "HTTPSリスナーのARN"
  value       = var.enable_https && var.ssl_certificate_arn != "" ? aws_lb_listener.https[0].arn : null
} 