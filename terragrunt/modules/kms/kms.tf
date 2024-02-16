# modules/kms/main.tf

# VPC Keys
resource "aws_kms_key" "private_subnet_key" {
  description             = "KMS key for resources in private subnets"
  deletion_window_in_days = 30
  enable_key_rotation     = true

  policy = file("./policies/subnet.json")
}

# S3 Keys
resource "aws_kms_key" "s3_key" {
  description             = "KMS key for S3"
  deletion_window_in_days = 30
  enable_key_rotation     = true

  policy = file("./policies/s3.json")
}

# SSM keys
resource "aws_kms_key" "ssm_key" {
  description             = "KMS key for parameter store"
  deletion_window_in_days = 30
  enable_key_rotation     = true

  policy = file("./policies/ssm.json")
}
