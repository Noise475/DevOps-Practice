# module/s3/main.tf
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Create remote state buckets
resource "aws_s3_bucket" "bucket_env_example" {
  for_each = toset(var.environments)

  bucket = "${each.key}-remote-state-tf-bucket"
  
  # Typically don't want this but allows easier create/destroy cycles
  force_destroy = true

  tags = {
    Name        = "${each.key}-remote-state-tf-bucket"
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

  bucket = each.value.bucket
  policy = templatefile("${path.module}/policies/s3-policy.json", { environment = each.key, role_arn = var.role_arn })
}
