variable "eks_public_key" {
  description = "EKS Instance key-value pair"
  type        = string
}

variable "environment" {
  description = "Current OU"
  type        = string
}

variable "environments" {
  description = "Map of all environments"
  type        = map(string)
  default = {
    dev     = "Development Environment"
    staging = "Staging Environment"
    prod    = "Production Environment"
  }
}

variable "tags" {
  description = "A map of tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "public_subnet_cidrs" {
  description = "Map of public subnet cidrs"
  type        = map(string)
}

variable "private_subnet_cidrs" {
  description = "Map of private subnet cidrs"
  type        = map(string)
}

variable "availability_zones" {
  description = "Map of availability zones"
  type        = map(string)
}
