variable "eks_public_key" {
  description = "EKS Instance key-value pair"
  type        = string
}

variable "environment" {
  description = "Current OU"
  type        = string
}

variable "environments" {
  description = "List of all environments"
  type        = map(string)
  default = {
    dev     = "Development Environment"
    staging = "Staging Environment"
    prod    = "Production Environment"
  }
}
