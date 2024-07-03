# modules/kms/main.tf

# VPC Keys
resource "aws_kms_key" "private_subnet_key" {
  description             = "KMS key for ${var.environment} resources in private subnets"
  deletion_window_in_days = 30
  enable_key_rotation     = true

  policy = templatefile("${path.module}/policies/kms-policy.json", {
    environment = var.environment
    role_arn    = var.role_arn
    account_id  = var.account_id
  })

  tags = var.tags
}

# S3 Keys
resource "aws_kms_key" "s3_key" {
  description             = "KMS key for ${var.environment} S3"
  deletion_window_in_days = 30
  enable_key_rotation     = true

  policy = templatefile("${path.module}/policies/kms-policy.json", {
    environment = var.environment
    role_arn    = var.role_arn
    account_id  = var.account_id
  })

  tags = var.tags
}

# SSM keys
resource "aws_kms_key" "ssm_key" {
  description             = "KMS key for ${var.environment} parameter store"
  deletion_window_in_days = 30
  enable_key_rotation     = true

  policy = templatefile("${path.module}/policies/kms-policy.json", {
    environment = var.environment
    role_arn    = var.role_arn
    account_id  = var.account_id
  })

  tags = var.tags
}

# Create aliases for the KMS keys
resource "aws_kms_alias" "s3_key_alias" {
  name          = "alias/${var.environment}-tf-state-key"
  target_key_id = aws_kms_key.s3_key.key_id
}

resource "aws_kms_alias" "ssm_key_alias" {
  name          = "alias/${var.environment}-parameter-store-key"
  target_key_id = aws_kms_key.ssm_key.key_id
}

resource "aws_kms_alias" "private_subnet_key_alias" {
  name          = "alias/${var.environment}-private-subnet-key"
  target_key_id = aws_kms_key.private_subnet_key.key_id
}
