# AWS Terraform モジュールコレクション

このリポジトリは、AWSでさまざまなアーキテクチャを構築するためのTerraformモジュールを提供します。

## アーキテクチャ概要

以下の主要なアーキテクチャパターンに対応したモジュールを提供しています：

### マイクロサービスアーキテクチャ

ECS Fargateを使用したコンテナベースのマイクロサービスデプロイメントを簡単に実現できます。

主な構成要素：
- **VPC** - マイクロサービス環境用の独立したネットワーク
- **セキュリティグループ** - ALBとECSサービス用のネットワークアクセス制御
- **ALB (Application Load Balancer)** - サービスへのHTTP/HTTPSトラフィックルーティング
- **ECS Cluster** - Fargateタスクを実行するクラスター
- **Service Discovery** - サービス間通信のためのDNSベースのサービスディスカバリー
- **ECS Services** - 個々のマイクロサービスの定義とデプロイメント
- **Auto Scaling** - サービスの負荷に基づいた自動スケーリング

### サーバーレスアーキテクチャ

AWS Lambda、API Gateway、DynamoDBなどを活用したサーバーレスアプリケーションを構築できます。

主な構成要素：
- **Lambda関数** - イベント駆動型の処理を実行
- **API Gateway** - RESTful APIエンドポイントを提供
- **DynamoDB** - スケーラブルなNoSQLデータストレージ
- **CloudWatch** - ログ管理と監視
- **IAM Roles** - セキュアな権限管理
- **S3** - 静的アセット保存とイベントトリガー

### 静的ウェブサイトホスティング

S3とCloudFrontを使用した高速でセキュアな静的ウェブサイトホスティングを実現します。

主な構成要素：
- **S3バケット** - ウェブサイトのコンテンツを保存
- **CloudFront** - コンテンツのグローバル配信とキャッシュ
- **ACM証明書** - HTTPSサポート
- **Route 53** - DNSルーティング（オプション）
- **Lambda@Edge** - リクエスト/レスポンス処理のカスタマイズ（オプション）

### 3層アーキテクチャ

従来の3層（プレゼンテーション、アプリケーション、データ）アーキテクチャをAWS上に構築します。

主な構成要素：
- **VPC** - 複数のサブネットに分割されたネットワーク環境
- **ALB** - フロントエンドのロードバランシング
- **EC2またはECS** - アプリケーション層
- **RDS** - リレーショナルデータベース
- **ElastiCache** - 高速キャッシュレイヤー
- **Security Groups** - 各層間のアクセス制御
- **Auto Scaling** - サーバーリソースの自動調整
- **CloudWatch** - モニタリングとアラート

## モジュール構造

```
modules/
  ├── microservices/        # マイクロサービス環境のモジュール
  │   ├── alb/              # ALB設定
  │   ├── ecs_cluster/      # ECSクラスター設定
  │   ├── ecs_services/     # ECSサービス設定
  │   ├── service_discovery/ # サービスディスカバリー設定
  │   ├── security_groups/  # セキュリティグループ設定
  │   ├── vpc/              # VPC設定
  │   ├── alb_listener_rules/ # ALBリスナールール設定
  │   ├── main.tf           # 親モジュールのメイン設定
  │   ├── variables.tf      # 変数定義
  │   └── outputs.tf        # 出力定義
  │
  ├── serverless/           # サーバーレス環境のモジュール
  │   ├── api_gateway/      # API Gateway設定
  │   ├── lambda/           # Lambda関数設定
  │   ├── dynamodb/         # DynamoDB設定
  │   ├── s3/               # S3バケット設定
  │   ├── main.tf           # 親モジュールのメイン設定
  │   ├── variables.tf      # 変数定義
  │   └── outputs.tf        # 出力定義
  │
  ├── static-web/           # 静的ウェブサイトホスティングモジュール
  │   ├── s3/               # S3バケット設定
  │   ├── cloudfront/       # CloudFront設定
  │   ├── acm/              # ACM証明書設定
  │   ├── main.tf           # 親モジュールのメイン設定
  │   ├── variables.tf      # 変数定義
  │   └── outputs.tf        # 出力定義
  │
  └── three-tier/           # 3層アーキテクチャモジュール
      ├── vpc/              # VPC設定
      ├── alb/              # ALB設定
      ├── ec2/              # EC2インスタンス設定
      ├── rds/              # RDSデータベース設定
      ├── elasticache/      # ElastiCacheクラスター設定
      ├── main.tf           # 親モジュールのメイン設定
      ├── variables.tf      # 変数定義
      └── outputs.tf        # 出力定義
```

## 使用方法

各アーキテクチャパターンの使用例を以下に示します。

### マイクロサービスアーキテクチャの使用例

```hcl
module "microservices" {
  source = "./modules/microservices"

  project_name = "myapp"
  environment  = "dev"
  
  # VPC設定
  vpc_cidr           = "10.0.0.0/16"
  availability_zones = ["ap-northeast-1a", "ap-northeast-1c"]
  
  # サービス定義
  services = {
    api = {
      container_port             = 8080
      container_image            = "123456789012.dkr.ecr.ap-northeast-1.amazonaws.com/api:latest"
      cpu                        = 512
      memory                     = 1024
      desired_count              = 2
      max_capacity               = 5
      min_capacity               = 1
      health_check_path          = "/health"
      health_check_grace_period  = 60
      deployment_maximum_percent = 200
      deployment_minimum_percent = 100
      environment_variables      = {
        "ENV" = "development"
      }
      secrets                    = {}
      create_alb_target_group    = true
      enable_service_discovery   = true
      service_discovery_dns_ttl  = 10
      service_discovery_routing_policy = "MULTIVALUE"
      task_role_arn              = ""
      execution_role_arn         = ""
      enable_execute_command     = true
      listener_rules = [
        {
          path_pattern = "/api/*"
          host_header  = ""
          priority     = 100
        }
      ]
    }
  }
}
```

### サーバーレスアーキテクチャの使用例

```hcl
module "serverless_api" {
  source = "./modules/serverless"

  project_name = "serverless-app"
  environment  = "dev"
  
  # API Gateway設定
  api_name        = "my-api"
  api_description = "My Serverless API"
  
  # Lambda関数設定
  lambda_functions = {
    user_service = {
      handler       = "index.handler"
      runtime       = "nodejs16.x"
      source_path   = "./src/user-service"
      memory_size   = 256
      timeout       = 30
      environment_variables = {
        "STAGE" = "development"
      }
      api_routes = [
        {
          path        = "/users"
          method      = "GET"
          authorizer  = false
        },
        {
          path        = "/users/{id}"
          method      = "GET"
          authorizer  = false
        }
      ]
    }
  }
  
  # DynamoDB設定
  dynamodb_tables = {
    users = {
      hash_key       = "user_id"
      read_capacity  = 5
      write_capacity = 5
      attributes = [
        {
          name = "user_id"
          type = "S"
        }
      ]
    }
  }
}
```

### 静的ウェブサイトホスティングの使用例

```hcl
module "static_website" {
  source = "./modules/static-web"

  project_name    = "my-website"
  environment     = "prod"
  domain_name     = "example.com"
  alternative_domains = ["www.example.com"]
  
  # S3設定
  index_document  = "index.html"
  error_document  = "error.html"
  
  # CloudFront設定
  enable_https          = true
  create_acm_certificate = true
  create_route53_record  = true
  
  # キャッシュ設定
  cache_policy = {
    default_ttl = 86400
    min_ttl     = 0
    max_ttl     = 31536000
  }
}
```

### 3層アーキテクチャの使用例

```hcl
module "three_tier_app" {
  source = "./modules/three-tier"

  project_name = "web-app"
  environment  = "staging"
  
  # VPC設定
  vpc_cidr           = "10.0.0.0/16"
  availability_zones = ["ap-northeast-1a", "ap-northeast-1c"]
  
  # ALB設定
  enable_https       = true
  domain_name        = "app.example.com"
  
  # EC2設定
  instance_type      = "t3.medium"
  instance_count     = 2
  key_name           = "my-key-pair"
  ami_id             = "ami-0123456789abcdef0"
  
  # RDS設定
  db_engine          = "postgres"
  db_engine_version  = "13.4"
  db_instance_class  = "db.t3.small"
  db_name            = "appdb"
  db_username        = "dbadmin"
  db_password        = "your-secure-password"
  db_storage_size    = 20
  
  # ElastiCache設定
  elasticache_engine = "redis"
  elasticache_node_type = "cache.t3.micro"
  elasticache_nodes     = 1
}
```

## 入力変数

各モジュールは多数の入力変数をサポートしています。詳細については各モジュールの `variables.tf` ファイルを参照してください。

## 出力

各モジュールは関連するAWSリソースのIDs、ARNs、エンドポイントなどの重要な情報を出力します。

## 要件

- Terraform 1.0以上
- AWS CLI 2.0以上（ローカル開発用）
- AWSアカウントと適切なIAM権限

## ライセンス

[MIT](/LICENSE)

## 注意事項

- 本番環境で使用する前に、セキュリティおよびパフォーマンスの最適化を検討してください。
- 使用状況によってはAWSの料金が発生します。コスト管理を適切に行ってください。 