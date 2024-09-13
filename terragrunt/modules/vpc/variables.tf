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
  type        = list(string)
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

variable "ou_role_name" {
  description = "Current env iam role name"
  type        = string
}

variable "availability_zones" {
  description = "Map of availability zones"
  type        = map(string)
}

variable "cidr_block" {
  description = "VPC cidr block range"
  type        = string
}

variable "role_arn" {
  description = "EKS role ARN"
  type        = string
}
