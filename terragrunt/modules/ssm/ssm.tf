# module/ssm/main.tf
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

resource "aws_ssm_parameter" "environment" {
  for_each = toset(var.environments)

  name        = "/${each.key}/environment"
  description = each.value
  type        = "SecureString"
  value       = each.key

  tags = var.tags
}


resource "aws_ssm_parameter" "region" {
  for_each = toset(var.environments)

  name        = "/${each.key}/region"
  description = "Current aws region"
  type        = "SecureString"
  value       = var.region

  tags = var.tags
}

resource "aws_ssm_parameter" "account_id" {
  for_each = toset(var.environments)

  name        = "/${each.key}/account_id"
  description = "AWS Account ID"
  type        = "SecureString"
  value       = var.account_id



  tags = var.tags
}

resource "aws_ssm_parameter" "org_id" {
  for_each = toset(var.environments)

  name        = "/${each.key}/org_id"
  description = "AWS Organization ID"
  type        = "SecureString"
  value       = var.org_id

  tags = var.tags
}

resource "aws_ssm_parameter" "role_arn" {
  for_each = toset(var.environments)

  name        = "/${each.key}/role_arn"
  description = "Service Account role ARN for ${each.key} Organization"
  type        = "SecureString"
  value       = var.role_arn

  tags = var.tags
}

resource "aws_ssm_parameter" "sso_instance_arn" {
  for_each = toset(var.environments)

  name        = "/${each.key}/sso_instance_arn"
  description = "SSO Instance ARN for AWS Account ID:${var.account_id} access"
  type        = "SecureString"
  value       = var.sso_instance_arn

  tags = var.tags
}

resource "aws_ssm_parameter" "permission_set_arn" {
  for_each = toset(var.environments)

  name        = "/${each.key}/permission_set_arn"
  description = "SSO Instance ARN for AWS Account ID:${var.account_id} access"
  type        = "SecureString"
  value       = var.permission_set_arn

  tags = var.tags
}

resource "aws_ssm_parameter" "sso_group_id" {
  for_each = toset(var.environments)

  name        = "/${each.key}/sso_group_id"
  description = "SSO Instance group ID"
  type        = "SecureString"
  value       = var.sso_group_id

  tags = var.tags
}
