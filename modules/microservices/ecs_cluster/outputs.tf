output "cluster_id" {
  description = "作成されたECSクラスターのID"
  value       = aws_ecs_cluster.this.id
}

output "cluster_arn" {
  description = "作成されたECSクラスターのARN"
  value       = aws_ecs_cluster.this.arn
}

output "cluster_name" {
  description = "作成されたECSクラスターの名前"
  value       = aws_ecs_cluster.this.name
}

output "log_group_name" {
  description = "ECSクラスターのCloudWatchロググループ名"
  value       = aws_cloudwatch_log_group.this.name
}

output "log_group_arn" {
  description = "ECSクラスターのCloudWatchロググループARN"
  value       = aws_cloudwatch_log_group.this.arn
} 