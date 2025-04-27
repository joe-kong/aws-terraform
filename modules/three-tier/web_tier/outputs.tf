output "asg_id" {
  description = "ID of the auto scaling group"
  value       = aws_autoscaling_group.this.id
}

output "asg_name" {
  description = "Name of the auto scaling group"
  value       = aws_autoscaling_group.this.name
}

output "asg_arn" {
  description = "ARN of the auto scaling group"
  value       = aws_autoscaling_group.this.arn
}

output "launch_template_id" {
  description = "ID of the launch template"
  value       = aws_launch_template.this.id
}

output "launch_template_name" {
  description = "Name of the launch template"
  value       = aws_launch_template.this.name
}

output "scale_up_policy_arn" {
  description = "ARN of the scale up policy"
  value       = aws_autoscaling_policy.scale_up.arn
}

output "scale_down_policy_arn" {
  description = "ARN of the scale down policy"
  value       = aws_autoscaling_policy.scale_down.arn
} 