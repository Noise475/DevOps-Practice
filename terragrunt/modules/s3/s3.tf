# module/s3/main.tf

# Create remote state buckets
resource "aws_s3_bucket" "bucket-env-example" {
  bucket = "${var.environment}-remote-state-terraform-bucket"

  tags = {
    Name        = "${var.environment}-remote-state-terraform-bucket"
    Environment = var.environment
  }
}

# Add kms key encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "encrypt_example" {
  bucket = aws_s3_bucket.bucket-env-example.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.s3_key_arn
      sse_algorithm     = "aws:kms"
    }
  }
}

# Create S3 terrafrom access policy
resource "aws_s3_bucket_policy" "tf_policy" {
  bucket = aws_s3_bucket.bucket-env-example.id
  policy = templatefile("./policies/s3-policy.json", { environment = var.environment })
}
