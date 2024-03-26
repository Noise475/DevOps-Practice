resource "aws_ssm_parameter" "ou_role_arn" {
  name        = "/${var.environment}/ou_role_arn"
  description = "The parameter description"
  type        = "SecureString"
  value       = var.ou_role_arn

  tags = {
    environment = "production"
  }
}
