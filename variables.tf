variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "cost_threshold" {
  description = "Cost threshold in USD for alerts"
  type        = number
  default     = 10.0
}

variable "alert_email" {
  description = "Email address for cost alerts"
  type        = string
}

variable "schedule_expression" {
  description = "CloudWatch Events schedule expression for cost logger"
  type        = string
  default     = "rate(1 day)"
}

variable "dashboard_domain" {
  description = "Domain name for the dashboard"
  type        = string
  default     = "cost-dashboard.example.com"
}