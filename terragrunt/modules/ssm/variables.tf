variable "environment" {
  description = "Current environment"
  type        = string
}

variable "environments" {
  description = "Map of environments"
  type        = list(string)
}

variable "region" {
  description = "Current aws region"
  type        = string
}


variable "role_arn" {
  description = "Current organization/environment role ARN"
  type        = string
}

variable "account_id" {
  description = "AWS Account ID"
  type        = string
}

variable "sso_instance_arn" {
  description = "ARN for SSO instance"
  type        = string
}

variable "permission_set_arn" {
  description = "permssion set ARN for SSO instance"
  type        = string
}

variable "sso_group_id" {
  description = "SSO group ID"
  type        = string
}

variable "tags" {
  description = "A map of tags to apply to all resources"
  type        = map(string)
}

variable "org_id" {
  description = "AWS Organization ID"
  type        = string
}
