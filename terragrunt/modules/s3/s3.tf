# module/s3/main.tf

resource "aws_s3_bucket" "bucket-env-example" {
  bucket = "${var.environment}-remote-state-terraform-bucket"

  tags = {
    Name        = "${var.environment}-remote-state-terraform-bucket"
    Environment = var.environment
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "encrypt_example" {
  bucket = aws_s3_bucket.bucket-env-example.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = module.kms.aws_kms_key.s3_key.arn
      sse_algorithm     = "aws:kms"
    }
  }
}
