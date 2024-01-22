# modules/kms/outputs.tf

output "s3_key_id" {
  value = aws_kms_key.s3_key.key_id
}