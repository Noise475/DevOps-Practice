# modules/kms/vartiables.tf
variable "role_arn" {
  description = "AWS role to grant kms permissions"
  type        = string
}

variable "environment" {
  description = "Current AWS Environment"
  type        = string
}

variable "account_id" {
  description = "AWS account"
  type        = string
}

variable "tags" {
  description = "A map of tags to apply to all resources"
  type        = map(string)
  default     = {}
}
