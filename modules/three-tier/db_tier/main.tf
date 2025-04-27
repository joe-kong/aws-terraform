resource "aws_db_subnet_group" "this" {
  name       = "${var.name_prefix}-db-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "${var.name_prefix}-db-subnet-group"
  }
}

resource "aws_db_parameter_group" "this" {
  name   = "${var.name_prefix}-db-parameter-group"
  family = "${var.engine}${var.engine_version}"

  parameter {
    name  = "character_set_server"
    value = "utf8"
  }

  parameter {
    name  = "character_set_client"
    value = "utf8"
  }

  tags = {
    Name = "${var.name_prefix}-db-parameter-group"
  }
}

resource "aws_db_instance" "this" {
  identifier           = "${var.name_prefix}-db"
  engine               = var.engine
  engine_version       = var.engine_version
  instance_class       = var.instance_class
  allocated_storage    = var.allocated_storage
  storage_type         = "gp2"
  storage_encrypted    = true
  db_name              = var.db_name
  username             = var.username
  password             = var.password
  parameter_group_name = aws_db_parameter_group.this.name
  option_group_name    = var.option_group_name
  db_subnet_group_name = aws_db_subnet_group.this.name

  vpc_security_group_ids = [var.security_group_id]

  multi_az                     = var.multi_az
  backup_retention_period      = var.backup_retention_period
  backup_window                = var.backup_window
  maintenance_window           = var.maintenance_window
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports
  auto_minor_version_upgrade   = var.auto_minor_version_upgrade
  skip_final_snapshot          = var.skip_final_snapshot
  final_snapshot_identifier    = "${var.name_prefix}-db-final-snapshot"
  deletion_protection          = var.deletion_protection
  copy_tags_to_snapshot        = true
  performance_insights_enabled = var.performance_insights_enabled

  tags = {
    Name = "${var.name_prefix}-db"
  }

  lifecycle {
    prevent_destroy = false
  }
}

# CloudWatchアラーム for DBインスタンス
resource "aws_cloudwatch_metric_alarm" "db_cpu_high" {
  alarm_name          = "${var.name_prefix}-db-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = 120
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "This metric monitors RDS CPU utilization"

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.this.id
  }
}

resource "aws_cloudwatch_metric_alarm" "db_memory_low" {
  alarm_name          = "${var.name_prefix}-db-memory-low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "FreeableMemory"
  namespace           = "AWS/RDS"
  period              = 120
  statistic           = "Average"
  threshold           = 1000000000  # 1GB in bytes
  alarm_description   = "This metric monitors RDS freeable memory"

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.this.id
  }
}

resource "aws_cloudwatch_metric_alarm" "db_storage_low" {
  alarm_name          = "${var.name_prefix}-db-storage-low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/RDS"
  period              = 120
  statistic           = "Average"
  threshold           = 5000000000  # 5GB in bytes
  alarm_description   = "This metric monitors RDS free storage space"

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.this.id
  }
} 