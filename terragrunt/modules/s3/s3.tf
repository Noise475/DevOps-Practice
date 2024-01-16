# module/s3/main.tf

resource "aws_s3_bucket" "dev-state-example" {
  bucket = "${var.environment}-terraform-state-bucket"

  tags = {
    Name        = "terraform-remote-state-bucket"
    Environment = var.environment
  }
}
