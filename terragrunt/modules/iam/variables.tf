variable "region" {
  description = "current AWS region"
  type        = string
}

variable "environment" {
  description = "current aws environment"
  type        = string
}

variable "environments" {
  description = "List of AWS environments"
  type        = list(string)
}


variable "account_id" {
  description = "AWS Account ID"
  type        = string
}

variable "org_id" {
  description = "AWS Organization ID"
  type        = string
}

# variable "sso_instance_arn" {
#   description = "AWS SSO (IAM IC) ARN"
#   type = string
# }

# variable "permission_set_arn" {
#   description = "AWS SSO (IAM IC) Permission Set(policies) ARN"
#   type = string
# }

# variable "sso_group_id" {
#   description = "AWS SSO (IAM IC) Permission Set(policies) ARN"
#   type = string
# }
