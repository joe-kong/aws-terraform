# ALB用セキュリティグループ
resource "aws_security_group" "alb" {
  name        = "${var.name_prefix}-alb-sg"
  description = "Security group for Application Load Balancer"
  vpc_id      = var.vpc_id

  # インバウンド：HTTPトラフィック
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.alb_ingress_cidr_blocks
    description = "HTTP traffic"
  }

  # インバウンド：HTTPSトラフィック
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.alb_ingress_cidr_blocks
    description = "HTTPS traffic"
  }

  # アウトバウンド：すべてのトラフィック
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name = "${var.name_prefix}-alb-sg"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# サービス用セキュリティグループ
resource "aws_security_group" "services" {
  name        = "${var.name_prefix}-services-sg"
  description = "Security group for ECS services"
  vpc_id      = var.vpc_id

  # アプリケーションポートからのインバウンドトラフィック（ALBからの接続許可）
  dynamic "ingress" {
    for_each = toset(var.app_ports)
    content {
      from_port       = ingress.value
      to_port         = ingress.value
      protocol        = "tcp"
      security_groups = [aws_security_group.alb.id]
      description     = "Allow traffic from ALB on port ${ingress.value}"
    }
  }

  # サービスディスカバリ用のDNSポート
  ingress {
    from_port       = 53
    to_port         = 53
    protocol        = "tcp"
    self            = true
    description     = "Allow DNS TCP traffic for service discovery"
  }

  ingress {
    from_port       = 53
    to_port         = 53
    protocol        = "udp"
    self            = true
    description     = "Allow DNS UDP traffic for service discovery"
  }

  # サービス間通信
  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    self            = true
    description     = "Allow all traffic between services"
  }

  # アウトバウンド：すべてのトラフィック
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name = "${var.name_prefix}-services-sg"
  }

  lifecycle {
    create_before_destroy = true
  }
} 