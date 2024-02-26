variable "region" {
  description = "current AWS region"
  type        = string
}

variable "environment" {
  description = "current aws environment"
  type        = string
}

variable "account_id" {
  description = "AWS Account ID"
  type        = string
}

variable "org_id" {
  description = "AWS Organization ID"
  type = string
}
