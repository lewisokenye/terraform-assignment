# API Gateway
# API Gateway
resource "aws_api_gateway_rest_api" "cost_api" {
  name        = "cost-tracker-api"
  description = "API for cost tracking data"
}

resource "aws_api_gateway_resource" "costs" {
  rest_api_id = aws_api_gateway_rest_api.cost_api.id
  parent_id   = aws_api_gateway_rest_api.cost_api.root_resource_id
  path_part   = "costs"
}

resource "aws_api_gateway_method" "get_costs" {
  rest_api_id   = aws_api_gateway_rest_api.cost_api.id
  resource_id   = aws_api_gateway_resource.costs.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id = aws_api_gateway_rest_api.cost_api.id
  resource_id = aws_api_gateway_resource.costs.id
  http_method = aws_api_gateway_method.get_costs.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.cost_api.invoke_arn
}

resource "aws_lambda_permission" "api_gateway_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.cost_api.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.cost_api.execution_arn}/*/*/*"
}

resource "aws_api_gateway_deployment" "api_deployment" {
  depends_on = [aws_api_gateway_integration.lambda_integration]

  rest_api_id = aws_api_gateway_rest_api.cost_api.id

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "prod" {
  stage_name    = "prod"
  rest_api_id   = aws_api_gateway_rest_api.cost_api.id
  deployment_id = aws_api_gateway_deployment.api_deployment.id
}


# API Lambda function
resource "aws_lambda_function" "cost_api" {
  filename         = data.archive_file.cost_api_zip.output_path
  function_name    = "cost-api"
  role            = aws_iam_role.lambda_role.arn
  handler         = "main.lambda_handler"
  runtime         = "python3.9"
  timeout         = 30
  memory_size     = 128

  environment {
    variables = {
      DYNAMODB_TABLE = aws_dynamodb_table.cost_logs.name
    }
  }
}

data "archive_file" "cost_api_zip" {
  type        = "zip"
  source_dir  = "${path.module}/lambda/cost-api"
  output_path = "${path.module}/lambda/cost-api.zip"
}
