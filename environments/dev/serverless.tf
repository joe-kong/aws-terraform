module "serverless" {
  source = "../../modules/serverless"

  project_name = "myapp"
  environment  = "dev"

  # VPC設定
  create_vpc = true
  vpc_cidr = "10.1.0.0/16"
  availability_zones = ["ap-northeast-1a", "ap-northeast-1c"]
  private_subnet_cidrs = ["10.1.1.0/24", "10.1.2.0/24"]
  public_subnet_cidrs = ["10.1.101.0/24", "10.1.102.0/24"]

  # API Gateway設定
  api_gateway_description = "API Gateway for My Serverless App"
  api_gateway_cors_allow_origins = ["*"]
  api_gateway_logging_level = "INFO"
  api_gateway_metrics_enabled = true

  # Lambda設定
  lambda_handler = "index.handler"
  lambda_runtime = "nodejs18.x"
  lambda_timeout = 30
  lambda_memory_size = 128
  lambda_create_in_vpc = true
  lambda_environment_variables = {
    ENVIRONMENT = "dev"
    TABLE_NAME = "myapp-dev-table"
  }

  # DynamoDB設定
  dynamodb_billing_mode = "PAY_PER_REQUEST"
  dynamodb_hash_key = "id"
  dynamodb_hash_key_type = "S"
  dynamodb_ttl_enabled = true
  dynamodb_point_in_time_recovery_enabled = true
  dynamodb_attributes = [
    {
      name = "email"
      type = "S"
    },
    {
      name = "createdAt"
      type = "N"
    }
  ]
  dynamodb_global_secondary_indexes = [
    {
      name = "EmailIndex"
      hash_key = "email"
      range_key = "createdAt"
      projection_type = "ALL"
      non_key_attributes = []
      read_capacity = 5
      write_capacity = 5
    }
  ]

  # API Gateway ルート設定
  api_route_configs = [
    {
      path = "/users"
      method = "GET"
      operation_name = "GetUsers"
    },
    {
      path = "/users"
      method = "POST"
      operation_name = "CreateUser"
    },
    {
      path = "/users/{id}"
      method = "GET"
      operation_name = "GetUser"
    },
    {
      path = "/users/{id}"
      method = "PUT"
      operation_name = "UpdateUser"
    },
    {
      path = "/users/{id}"
      method = "DELETE"
      operation_name = "DeleteUser"
    }
  ]
} 