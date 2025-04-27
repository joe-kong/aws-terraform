output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "IDs of public subnets"
  value       = module.vpc.public_subnet_ids
}

output "private_app_subnet_ids" {
  description = "IDs of private application subnets"
  value       = module.vpc.private_app_subnet_ids
}

output "private_db_subnet_ids" {
  description = "IDs of private database subnets"
  value       = module.vpc.private_db_subnet_ids
}

output "alb_dns_name" {
  description = "DNS name of the application load balancer"
  value       = module.alb.alb_dns_name
}

output "alb_zone_id" {
  description = "Zone ID of the application load balancer"
  value       = module.alb.alb_zone_id
}

output "web_asg_name" {
  description = "Name of the web tier auto scaling group"
  value       = module.web_tier.asg_name
}

output "app_asg_name" {
  description = "Name of the application tier auto scaling group"
  value       = module.app_tier.asg_name
}

output "db_endpoint" {
  description = "Endpoint of the RDS database"
  value       = module.db_tier.db_endpoint
  sensitive   = false
}

output "db_address" {
  description = "Address of the RDS database"
  value       = module.db_tier.db_address
  sensitive   = false
}

output "security_group_ids" {
  description = "Map of security group IDs"
  value = {
    alb = module.security_groups.alb_security_group_id
    web = module.security_groups.web_security_group_id
    app = module.security_groups.app_security_group_id
    db  = module.security_groups.db_security_group_id
  }
} 