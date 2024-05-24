variable "environment" {
  description = "current deploy environment"
  type        = string
}

variable "s3_key_arn" {
  description = "kms key_id for s3"
  type        = string
}
