variable "ou_role" {
  description = "organzational unit role name"
  type = string
}

variable "region" {
  description = "current AWS region"
  type = string
  default = "us-east-2"
}

variable "environment" {
  description = "current aws environment"
  type = string
}
