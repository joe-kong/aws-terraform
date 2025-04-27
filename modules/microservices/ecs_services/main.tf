locals {
  service_full_name = "${var.name_prefix}-${var.service_name}"
  container_name    = var.service_name
}

# ECSタスク定義
resource "aws_ecs_task_definition" "this" {
  family                   = local.service_full_name
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = var.task_role_arn != "" ? var.task_role_arn : null

  container_definitions = jsonencode([
    {
      name      = local.container_name
      image     = var.container_image
      essential = true
      
      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = var.container_port
          protocol      = "tcp"
        }
      ]
      
      environment = [
        for key, value in var.environment_variables : {
          name  = key
          value = value
        }
      ]
      
      secrets = [
        for key, value in var.secrets : {
          name      = key
          valueFrom = value
        }
      ]
      
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/${local.service_full_name}"
          "awslogs-region"        = data.aws_region.current.name
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])

  tags = {
    Name = local.service_full_name
  }
}

# CloudWatch Logsグループ
resource "aws_cloudwatch_log_group" "this" {
  name              = "/ecs/${local.service_full_name}"
  retention_in_days = 30

  tags = {
    Name = "/ecs/${local.service_full_name}"
  }
}

# Service Discoveryサービス定義（オプション）
resource "aws_service_discovery_service" "this" {
  count = var.enable_service_discovery ? 1 : 0
  
  name = var.service_name

  dns_config {
    namespace_id = var.service_discovery_namespace_id

    dns_records {
      ttl  = var.service_discovery_dns_ttl
      type = "A"
    }

    routing_policy = var.service_discovery_routing_policy
  }

  health_check_custom_config {
    failure_threshold = 1
  }

  tags = {
    Name = "${local.service_full_name}-service-discovery"
  }
}

# ALB Target Group（オプション）
resource "aws_lb_target_group" "this" {
  count = var.create_target_group ? 1 : 0
  
  name        = substr(local.service_full_name, 0, min(32, length(local.service_full_name)))
  port        = var.container_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
  
  health_check {
    enabled             = true
    interval            = 30
    path                = var.health_check_path
    port                = "traffic-port"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 5
    matcher             = "200-299"
  }

  tags = {
    Name = local.service_full_name
  }
}

# ECSサービス
resource "aws_ecs_service" "this" {
  name                               = var.service_name
  cluster                            = var.cluster_id
  task_definition                    = aws_ecs_task_definition.this.arn
  desired_count                      = var.desired_count
  launch_type                        = "FARGATE"
  scheduling_strategy                = "REPLICA"
  health_check_grace_period_seconds  = var.health_check_grace_period
  enable_execute_command             = var.enable_execute_command
  deployment_maximum_percent         = var.deployment_maximum_percent
  deployment_minimum_healthy_percent = var.deployment_minimum_percent

  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = [var.security_group_id]
    assign_public_ip = false
  }

  # Service Discoveryの設定（オプション）
  dynamic "service_registries" {
    for_each = var.enable_service_discovery ? [1] : []
    content {
      registry_arn = aws_service_discovery_service.this[0].arn
    }
  }

  # ロードバランサーの設定（オプション）
  dynamic "load_balancer" {
    for_each = var.create_target_group || var.alb_target_group_arn != "" ? [1] : []
    content {
      target_group_arn = var.create_target_group ? aws_lb_target_group.this[0].arn : var.alb_target_group_arn
      container_name   = local.container_name
      container_port   = var.container_port
    }
  }

  tags = {
    Name = local.service_full_name
  }

  lifecycle {
    ignore_changes = [desired_count]
  }

  depends_on = [aws_cloudwatch_log_group.this]
}

# Auto Scaling
resource "aws_appautoscaling_target" "this" {
  max_capacity       = var.max_capacity
  min_capacity       = var.min_capacity
  resource_id        = "service/${split("/", var.cluster_id)[1]}/${aws_ecs_service.this.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

# CPU使用率によるスケーリングポリシー
resource "aws_appautoscaling_policy" "cpu" {
  name               = "${local.service_full_name}-cpu-scaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.this.resource_id
  scalable_dimension = aws_appautoscaling_target.this.scalable_dimension
  service_namespace  = aws_appautoscaling_target.this.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value       = 70.0
    scale_in_cooldown  = 300
    scale_out_cooldown = 60
  }
}

# メモリ使用率によるスケーリングポリシー
resource "aws_appautoscaling_policy" "memory" {
  name               = "${local.service_full_name}-memory-scaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.this.resource_id
  scalable_dimension = aws_appautoscaling_target.this.scalable_dimension
  service_namespace  = aws_appautoscaling_target.this.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }
    target_value       = 70.0
    scale_in_cooldown  = 300
    scale_out_cooldown = 60
  }
}

# 現在のAWSリージョンを取得
data "aws_region" "current" {} 