variable "environment" {
  description = "current deploy environment"
  type        = string
}

variable "environments" {
  description = "List of all environments"
  type = list(string)
}

variable "s3_key_arn" {
  description = "kms key_id for s3"
  type        = string
}

variable "tags" {
  description = "A map of tags to apply to all resources"
  type        = map(string)
  default     = {}
}
