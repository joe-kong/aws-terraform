output "alb_security_group_id" {
  description = "ID of ALB security group"
  value       = aws_security_group.alb.id
}

output "web_security_group_id" {
  description = "ID of web tier security group"
  value       = aws_security_group.web.id
}

output "app_security_group_id" {
  description = "ID of application tier security group"
  value       = aws_security_group.app.id
}

output "db_security_group_id" {
  description = "ID of database security group"
  value       = aws_security_group.db.id
} 