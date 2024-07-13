# modules/kms/outputs.tf

output "s3_key_arn" {
  value = aws_kms_key.s3_key.arn
}

output "ssm_key_arn" {
  value = aws_kms_key.ssm_key.arn
}

output "private_subnet_key_arn" {
  value = aws_kms_key.private_subnet_key.arn
}
