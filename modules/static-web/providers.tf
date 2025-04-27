provider "aws" {
  alias = "us_east_1"
  region = "us-east-1"  # CloudFrontはus-east-1のACM証明書のみをサポート
} 