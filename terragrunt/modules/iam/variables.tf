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

variable "github_repo" {
  description = "Github repo name"
  type        = string
  default     = "DevOps-Practice"
}

variable "oidc_audience" {
  description = "OIDC audience" # Useful for alternate aws address like amazonw.aws.com.cn
  type        = string
  default     = ""
}

variable "github_org" {
  description = "Github organization name"
  type        = string
  default     = ""
}

variable "table_name" {
  description = "Dynamodb table name"
  type        = string
}

variable "tags" {
  description = "A map of tags to apply to all resources"
  type        = map(string)
  default     = {}
}

