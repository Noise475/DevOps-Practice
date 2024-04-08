resource "aws_ssm_parameter" "ou_role_arn" {
  name        = "/${var.environment}/${var.environment}_role_arn"
  description = "Role ARN for current environment"
  type        = "SecureString"
  value       = var.role_arn

  tags = {
    environment = "${var.environment}"
  }
}
