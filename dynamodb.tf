resource "aws_dynamodb_table" "cost_logs" {
  name           = "cost-logs"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "date"
  range_key      = "service"

  attribute {
    name = "date"
    type = "S"
  }

  attribute {
    name = "service"
    type = "S"
  }

  ttl {
    attribute_name = "expiry_time"
    enabled        = true
  }

  tags = {
    Name = "cost-logs"
  }
}
