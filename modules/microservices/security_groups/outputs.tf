output "alb_security_group_id" {
  description = "ALB用セキュリティグループのID"
  value       = aws_security_group.alb.id
}

output "alb_security_group_arn" {
  description = "ALB用セキュリティグループのARN"
  value       = aws_security_group.alb.arn
}

output "services_security_group_id" {
  description = "サービス用セキュリティグループのID"
  value       = aws_security_group.services.id
}

output "services_security_group_arn" {
  description = "サービス用セキュリティグループのARN"
  value       = aws_security_group.services.arn
} 