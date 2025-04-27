output "db_instance_id" {
  description = "ID of the database instance"
  value       = aws_db_instance.this.id
}

output "db_instance_arn" {
  description = "ARN of the database instance"
  value       = aws_db_instance.this.arn
}

output "db_endpoint" {
  description = "Connection endpoint of the database"
  value       = aws_db_instance.this.endpoint
}

output "db_address" {
  description = "Address of the database"
  value       = aws_db_instance.this.address
}

output "db_port" {
  description = "Port of the database"
  value       = aws_db_instance.this.port
}

output "db_name" {
  description = "Name of the database"
  value       = aws_db_instance.this.db_name
}

output "db_username" {
  description = "Username for the database"
  value       = aws_db_instance.this.username
  sensitive   = true
}

output "db_subnet_group_id" {
  description = "ID of the database subnet group"
  value       = aws_db_subnet_group.this.id
}

output "db_parameter_group_id" {
  description = "ID of the database parameter group"
  value       = aws_db_parameter_group.this.id
} 