resource "aws_ssm_parameter" "environment" {
  name        = "/${var.environment}/environment"
  description = "Current deployment environment"
  type        = "SecureString"
  value       = var.environment

  tags = var.tags
}

resource "aws_ssm_parameter" "region" {
  name        = "/${var.environment}/region"
  description = "Current aws region"
  type        = "SecureString"
  value       = var.region

  tags = var.tags
}

resource "aws_ssm_parameter" "account_id" {
  name        = "/${var.environment}/account_id"
  description = "AWS Account ID"
  type        = "SecureString"
  value       = var.account_id

  tags = var.tags
}

resource "aws_ssm_parameter" "role_arn" {
  name        = "/${var.environment}/role_arn"
  description = "Service Account role ARN for ${var.environment} Organization"
  type        = "SecureString"
  value       = var.role_arn

  tags = var.tags
}

resource "aws_ssm_parameter" "sso_instance_arn" {
  name        = "/${var.environment}/sso_instance_arn"
  description = "SSO Instance ARN for AWS Account ID:${var.account_id} access"
  type        = "SecureString"
  value       = var.sso_instance_arn

  tags = var.tags
}

resource "aws_ssm_parameter" "permission_set_arn" {
  name        = "/${var.environment}/permission_set_arn"
  description = "SSO Instance ARN for AWS Account ID:${var.account_id} access"
  type        = "SecureString"
  value       = var.permission_set_arn

  tags = var.tags
}

resource "aws_ssm_parameter" "sso_group_id" {
  name        = "/${var.environment}/sso_group_id"
  description = "SSO Instance group ID"
  type        = "SecureString"
  value       = var.sso_group_id

  tags = var.tags
}
