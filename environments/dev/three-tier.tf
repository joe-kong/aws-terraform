module "three_tier" {
  source = "../../modules/three-tier"

  project_name = "myapp"
  environment  = "dev"

  # VPC設定
  vpc_cidr = "10.0.0.0/16"
  availability_zones = ["ap-northeast-1a", "ap-northeast-1c"]
  public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
  private_app_subnet_cidrs = ["10.0.11.0/24", "10.0.12.0/24"]
  private_db_subnet_cidrs = ["10.0.21.0/24", "10.0.22.0/24"]

  # ALB設定
  health_check_path = "/health"

  # Webサーバー設定
  web_instance_type = "t3.micro"
  web_min_size = 1
  web_max_size = 2
  web_desired_capacity = 1
  web_user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd
    echo '<h1>Hello from Web Server</h1>' > /var/www/html/index.html
    echo '<h2>Development Environment</h2>' >> /var/www/html/index.html
    echo '<p>Server Health Check</p>' > /var/www/html/health
  EOF

  # アプリサーバー設定
  app_instance_type = "t3.small"
  app_min_size = 1
  app_max_size = 2
  app_desired_capacity = 1
  app_user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y java-11-amazon-corretto
    mkdir -p /opt/app
    # ここにアプリケーションのセットアップを追加
  EOF

  # データベース設定
  db_instance_class = "db.t3.small"
  db_engine = "mysql"
  db_engine_version = "8.0"
  db_allocated_storage = 20
  db_username = "admin"
  db_password = "DevPassword123!" # 本番では必ずSSM Parameter StoreやSecretsManagerを使用すること
  db_multi_az = false
  db_skip_final_snapshot = true
} 