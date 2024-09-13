# module/s3/main.tf
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Generate a random ID for uniqueness
resource "random_id" "bucket_suffix" {
  byte_length = 4
}

# Create remote state buckets
resource "aws_s3_bucket" "bucket_env_example" {
  for_each = toset(var.environments)

  bucket = "${each.key}-example-bucket-${random_id.bucket_suffix.hex}"

  # Typically don't want this but allows easier create/destroy cycles
  force_destroy = true

  tags = {
    Name        = "${each.key}-example-bucket"
    Environment = each.key
  }
}

# Add kms key encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "encrypt_example" {
  for_each = aws_s3_bucket.bucket_env_example

  bucket = each.value.bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.s3_key_arn
      sse_algorithm     = "aws:kms"
    }
  }
}

# Enable Versioning
resource "aws_s3_bucket_versioning" "versioning_example" {
  for_each = aws_s3_bucket.bucket_env_example

  bucket = each.value.bucket

  versioning_configuration {
    status = "Enabled"
  }
}

# Create S3 terrafrom access policy
resource "aws_s3_bucket_policy" "s3_policy" {
  for_each = aws_s3_bucket.bucket_env_example
  bucket   = each.value.bucket

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          AWS = [
            "${var.role_arn}",
            "arn:aws:iam::590183659157:role/terraform_role"
          ]
        },
        Action = [
          "s3:*"
        ],
        Resource = [
          "arn:aws:s3:::${each.value.bucket}",
          "arn:aws:s3:::${each.value.bucket}/*"
        ]
      }
    ]
  })
}
