# module/s3/s3.tf

resource "aws_s3_bucket" "example" {
  bucket = "my-tf-test-bucket"

  tags = {
    Name        = "terraform-state-bucket"
    Environment = "Dev"
  }
}
