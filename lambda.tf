# Archive file for cost logger Lambda
data "archive_file" "cost_logger_zip" {
  type        = "zip"
  source_dir  = "${path.module}/lambda/cost-logger"
  output_path = "${path.module}/lambda/cost-logger.zip"
}
# Lambda function for cost logging
resource "aws_lambda_function" "cost_logger" {
  filename         = data.archive_file.cost_logger_zip.output_path
  function_name    = "cost-logger"
  role            = aws_iam_role.lambda_role.arn
  handler         = "main.lambda_handler"
  runtime         = "python3.9"
  timeout         = 300
  memory_size     = 128

  environment {
    variables = {
      DYNAMODB_TABLE = aws_dynamodb_table.cost_logs.name
    }
  }

  depends_on = [
    aws_iam_role_policy.lambda_policy
  ]
}
