# modules/kms/vartiables.tf

variable "role_arn" {
  description = "AWS role to grant kms permissions"
  type = string
}

variable "environment" {
  description = "Current AWS Environment"
  type = string
}