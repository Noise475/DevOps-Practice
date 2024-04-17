variable "environment" {
  description = "Current environment"
  type        = string
}

variable "role_arn" {
  description = "Current organization/environment role ARN"
  type        = string
}

variable "root_role_arn" {
  description = "root organization/environment role ARN"
  type        = string
}

variable "account_id" {
  description = "AWS Account ID"
  type        = string
}

variable "dev_role_arn" {
  description = "dev organization role arn"
  type        = string
  default     = ""
}

variable "staging_role_arn" {
  description = "staging organization role arn"
  type        = string
  default     = ""
}

variable "prod_role_arn" {
  description = "prod organization role arn"
  type        = string
  default     = ""
}

variable "sso_instance_arn" {
  description = "ARN for SSO instance"
  type        = string
  default     = ""
}

variable "permission_set_arn" {
  description = "permssion set ARN for SSO instance"
  type        = string
  default     = ""
}

variable "sso_group_id" {
  description = "SSO group ID"
  type        = string
  default     = ""
}
