variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "api_id" {
  description = "ID of the API Gateway"
  type        = string
}

variable "api_execution_arn" {
  description = "Execution ARN of the API Gateway"
  type        = string
}

variable "lambda_function_id" {
  description = "ID of the Lambda function"
  type        = string
}

variable "lambda_invoke_arn" {
  description = "Invoke ARN of the Lambda function"
  type        = string
}

variable "route_configs" {
  description = "List of route configurations for API Gateway"
  type = list(object({
    path        = string
    method      = string
    operation_name = string
  }))
  default = [
    {
      path           = "/items"
      method         = "GET"
      operation_name = "GetItems"
    },
    {
      path           = "/items"
      method         = "POST"
      operation_name = "CreateItem"
    },
    {
      path           = "/items/{id}"
      method         = "GET"
      operation_name = "GetItem"
    },
    {
      path           = "/items/{id}"
      method         = "PUT"
      operation_name = "UpdateItem"
    },
    {
      path           = "/items/{id}"
      method         = "DELETE"
      operation_name = "DeleteItem"
    }
  ]
} 