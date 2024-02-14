variable "ou_role" {
  description = "organzational unit role name"
  type        = string
}

variable "ou_names" {
  description = "List of OU names to create"
  type        = list(object({ name = string }))
  default     = [{ name = "dev" }, { name = "staging" }, { name = "prod" }]
}

variable "region" {
  description = "current AWS region"
  type        = string
}

variable "environment" {
  description = "current aws environment"
  type        = string
}
