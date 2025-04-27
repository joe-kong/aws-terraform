# Application Load Balancer
resource "aws_lb" "this" {
  name               = "${var.name_prefix}-alb"
  internal           = var.internal
  load_balancer_type = "application"
  security_groups    = var.security_group_ids
  subnets            = var.subnet_ids

  enable_deletion_protection = var.enable_deletion_protection
  enable_http2               = var.enable_http2
  idle_timeout               = var.idle_timeout
  ip_address_type            = var.ip_address_type

  dynamic "access_logs" {
    for_each = var.access_logs.enabled ? [1] : []
    content {
      bucket  = var.access_logs.bucket
      prefix  = var.access_logs.prefix
      enabled = true
    }
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-alb"
    }
  )
}

# ターゲットグループの作成
resource "aws_lb_target_group" "this" {
  for_each = var.target_groups

  name     = "${var.name_prefix}-tg-${each.key}"
  port     = each.value.port
  protocol = each.value.protocol
  vpc_id   = var.vpc_id

  target_type          = each.value.target_type
  deregistration_delay = each.value.deregistration_delay

  dynamic "health_check" {
    for_each = each.value.health_check.enabled ? [1] : []
    content {
      enabled             = true
      path                = each.value.health_check.path
      port                = each.value.health_check.port
      protocol            = each.value.health_check.protocol
      healthy_threshold   = each.value.health_check.healthy_threshold
      unhealthy_threshold = each.value.health_check.unhealthy_threshold
      timeout             = each.value.health_check.timeout
      interval            = each.value.health_check.interval
      matcher             = each.value.health_check.matcher
    }
  }

  dynamic "stickiness" {
    for_each = each.value.stickiness.enabled ? [1] : []
    content {
      enabled         = true
      type            = each.value.stickiness.type
      cookie_duration = each.value.stickiness.cookie_duration
    }
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-tg-${each.key}"
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}

# HTTPリスナーの作成
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  # HTTPSリダイレクトが有効で、HTTPSリスナーが作成される場合
  dynamic "default_action" {
    for_each = var.enable_https && var.http_redirect_to_https ? [1] : []
    content {
      type = "redirect"
      redirect {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }
  }

  # HTTPSリダイレクトが無効または、HTTPSリスナーが作成されない場合
  dynamic "default_action" {
    for_each = (!var.enable_https || !var.http_redirect_to_https) ? [1] : []
    content {
      type = "fixed-response"
      fixed_response {
        content_type = "text/plain"
        message_body = "No target groups configured"
        status_code  = "404"
      }
    }
  }
}

# HTTPSリスナーの作成（条件付き）
resource "aws_lb_listener" "https" {
  count = var.enable_https && var.ssl_certificate_arn != "" ? 1 : 0

  load_balancer_arn = aws_lb.this.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = var.ssl_policy
  certificate_arn   = var.ssl_certificate_arn

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "No target groups configured"
      status_code  = "404"
    }
  }
}

# リスナールールの作成
locals {
  # HTTPリスナーの対象となるターゲットグループ
  http_listener_target_groups = var.enable_https && var.http_redirect_to_https ? {} : var.target_groups

  # HTTPSリスナーの対象となるターゲットグループ
  https_listener_target_groups = var.enable_https && var.ssl_certificate_arn != "" ? var.target_groups : {}
}

# HTTPリスナールールの作成
resource "aws_lb_listener_rule" "http" {
  for_each = local.http_listener_target_groups

  listener_arn = aws_lb_listener.http.arn
  priority     = 100 + index(keys(local.http_listener_target_groups), each.key)

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this[each.key].arn
  }

  condition {
    path_pattern {
      values = ["/${each.key}*"]
    }
  }
}

# HTTPSリスナールールの作成
resource "aws_lb_listener_rule" "https" {
  for_each = local.https_listener_target_groups

  listener_arn = aws_lb_listener.https[0].arn
  priority     = 100 + index(keys(local.https_listener_target_groups), each.key)

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this[each.key].arn
  }

  condition {
    path_pattern {
      values = ["/${each.key}*"]
    }
  }
}