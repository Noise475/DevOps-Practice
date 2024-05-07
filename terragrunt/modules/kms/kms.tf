# modules/kms/main.tf

# VPC Keys
resource "aws_kms_key" "private_subnet_key" {
  description             = "KMS key for resources in private subnets"
  deletion_window_in_days = 30
  enable_key_rotation     = true

  policy = templatefile("./policies/kms-policy.json", {
    environment = "${var.environment}"
    role_arn    = "${var.role_arn}"
    account_id  = "${var.account_id}"
  })

  tags = {
    environment = var.environment
  }
}

# S3 Keys
resource "aws_kms_key" "s3_key" {
  description             = "KMS key for S3"
  deletion_window_in_days = 30
  enable_key_rotation     = true

  policy = templatefile("./policies/kms-policy.json", {
    environment = "${var.environment}"
    role_arn    = "${var.role_arn}"
    account_id  = "${var.account_id}"
  })

  tags = {
    environment = var.environment
  }
}

# SSM keys
resource "aws_kms_key" "ssm_key" {
  description             = "KMS key for parameter store"
  deletion_window_in_days = 30
  enable_key_rotation     = true

  policy = templatefile("./policies/kms-policy.json", {
    environment = "${var.environment}"
    role_arn    = "${var.role_arn}"
    account_id  = "${var.account_id}"
  })

  tags = {
    environment = var.environment
  }
}

resource "aws_kms_alias" "s3_key" {
  name          = "alias/${var.environment}-tf-state-key"
  target_key_id = aws_kms_key.s3_key.key_id
}

resource "aws_kms_alias" "ssm_key" {
  name          = "alias/${var.environment}-parameter-store-key"
  target_key_id = aws_kms_key.ssm_key.key_id
}

resource "aws_kms_alias" "private_subnet_key" {
  name          = "alias/${var.environment}-private-subnet-key"
  target_key_id = aws_kms_key.private_subnet_key.key_id
}
