resource "aws_cloudwatch_metric_alarm" "billing_alarm" {
  alarm_name          = "cost-threshold-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "EstimatedCharges"
  namespace           = "AWS/Billing"
  period              = "86400" # 24 hours
  statistic           = "Maximum"
  threshold           = var.cost_threshold
  alarm_description   = "Alarm when estimated charges exceed threshold"

  dimensions = {
    Currency = "USD"
  }

  alarm_actions = [aws_sns_topic.cost_alerts.arn]
}