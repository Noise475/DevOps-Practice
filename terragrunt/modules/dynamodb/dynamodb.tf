# modules/dynamodb/main.tf

resource "aws_dynamodb_table" "state_lock" {
  name         = "${var.environment}-terraform-lock-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = var.tags
}

