output "dynamodb_table_name" {
  description = "Name of the DynamoDB table"
  value       = aws_dynamodb_table.cost_logs.name
}

output "sns_topic_arn" {
  description = "ARN of the SNS topic for alerts"
  value       = aws_sns_topic.cost_alerts.arn
}

output "api_gateway_url" {
  description = "URL of the API Gateway"
  value       = "https://${aws_api_gateway_rest_api.cost_api.id}.execute-api.${var.aws_region}.amazonaws.com/${aws_api_gateway_stage.prod.stage_name}"
}

output "dashboard_url" {
  description = "URL of the cost dashboard"
  value       = "https://${aws_cloudfront_distribution.dashboard.domain_name}"
}

output "lambda_function_name" {
  description = "Name of the cost logger Lambda function"
  value       = aws_lambda_function.cost_logger.function_name
}

output "api_invoke_url" {
  description = "Full invoke URL for the API"
  value       = "https://${aws_api_gateway_rest_api.cost_api.id}.execute-api.${var.aws_region}.amazonaws.com/${aws_api_gateway_stage.prod.stage_name}/costs"
}