# modules/kms/outputs.tf

output "s3_key_id" {
  value = aws_kms_key.s3_key.key_id
}

output "ssm_key_id" {
  value = aws_kms_key.ssm_key.key_id
}

output "private_subnet_key_id" {
  value = aws_kms_key.private_subnet_key.id
}
