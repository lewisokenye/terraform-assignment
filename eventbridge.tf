resource "aws_cloudwatch_event_rule" "daily_cost_log" {
  name                = "daily-cost-log"
  description         = "Trigger cost logging daily"
  schedule_expression = var.schedule_expression
}

resource "aws_cloudwatch_event_target" "trigger_cost_logger" {
  rule      = aws_cloudwatch_event_rule.daily_cost_log.name
  target_id = "CostLogger"
  arn       = aws_lambda_function.cost_logger.arn
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.cost_logger.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.daily_cost_log.arn
}
