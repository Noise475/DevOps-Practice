# kms/main.tf

resource "aws_kms_key" "private_subnet_key" {
  description             = "KMS key for resources in private subnets"
  deletion_window_in_days = 10
  enable_key_rotation     = true

  policy = file("./policies/subnet.json")
}

output "private_subnet_key_arn" {
  value = aws_kms_key.private_subnet_key.arn
}

resource "aws_kms_key" "s3_key" {
  description             = "KMS key for S3"
  deletion_window_in_days = 10
  enable_key_rotation     = true

  policy = file("./policies/s3.json")
}

output "s3_key_arn" {
  value = aws_kms_key.s3_key.arn
}
