module "microservices" {
  source = "../../modules/microservices"

  project_name = "myapp"
  environment  = "dev"

  # VPC設定
  vpc_cidr = "10.2.0.0/16"
  availability_zones = ["ap-northeast-1a", "ap-northeast-1c"]
  public_subnet_cidrs = ["10.2.1.0/24", "10.2.2.0/24"]
  private_subnet_cidrs = ["10.2.11.0/24", "10.2.12.0/24"]
  enable_nat_gateway = true
  single_nat_gateway = true

  # ALB設定
  health_check_path = "/health"
  enable_https = false

  # サービスディスカバリ
  service_discovery_namespace = "dev.myapp.local"

  # サービス定義
  services = {
    # ユーザーサービス
    "user-service" = {
      container_port = 8080
      container_image = "nginx:latest" # 実際のアプリケーションイメージに置き換える
      cpu = 256
      memory = 512
      desired_count = 1
      max_capacity = 2
      min_capacity = 1
      health_check_path = "/health"
      health_check_grace_period = 60
      deployment_maximum_percent = 200
      deployment_minimum_percent = 100
      environment_variables = {
        "SPRING_PROFILES_ACTIVE" = "dev"
        "JAVA_OPTS" = "-Xms256m -Xmx512m"
      }
      secrets = {}
      create_alb_target_group = true
      enable_service_discovery = true
      service_discovery_dns_ttl = 10
      service_discovery_routing_policy = "MULTIVALUE"
      task_role_arn = ""
      execution_role_arn = ""
      enable_execute_command = true
      listener_rules = [
        {
          path_pattern = "/users*"
          host_header = ""
          priority = 100
        }
      ]
    },

    # 商品サービス
    "product-service" = {
      container_port = 8080
      container_image = "nginx:latest" # 実際のアプリケーションイメージに置き換える
      cpu = 256
      memory = 512
      desired_count = 1
      max_capacity = 2
      min_capacity = 1
      health_check_path = "/health"
      health_check_grace_period = 60
      deployment_maximum_percent = 200
      deployment_minimum_percent = 100
      environment_variables = {
        "SPRING_PROFILES_ACTIVE" = "dev"
        "JAVA_OPTS" = "-Xms256m -Xmx512m"
      }
      secrets = {}
      create_alb_target_group = true
      enable_service_discovery = true
      service_discovery_dns_ttl = 10
      service_discovery_routing_policy = "MULTIVALUE"
      task_role_arn = ""
      execution_role_arn = ""
      enable_execute_command = true
      listener_rules = [
        {
          path_pattern = "/products*"
          host_header = ""
          priority = 110
        }
      ]
    },

    # 注文サービス
    "order-service" = {
      container_port = 8080
      container_image = "nginx:latest" # 実際のアプリケーションイメージに置き換える
      cpu = 256
      memory = 512
      desired_count = 1
      max_capacity = 2
      min_capacity = 1
      health_check_path = "/health"
      health_check_grace_period = 60
      deployment_maximum_percent = 200
      deployment_minimum_percent = 100
      environment_variables = {
        "SPRING_PROFILES_ACTIVE" = "dev"
        "JAVA_OPTS" = "-Xms256m -Xmx512m"
      }
      secrets = {}
      create_alb_target_group = true
      enable_service_discovery = true
      service_discovery_dns_ttl = 10
      service_discovery_routing_policy = "MULTIVALUE"
      task_role_arn = ""
      execution_role_arn = ""
      enable_execute_command = true
      listener_rules = [
        {
          path_pattern = "/orders*"
          host_header = ""
          priority = 120
        }
      ]
    }
  }

  # タグ
  tags = {
    Environment = "dev"
    Project     = "myapp"
    ManagedBy   = "terraform"
  }
} 