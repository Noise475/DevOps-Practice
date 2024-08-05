# modules/eks/variables.tf

variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC where the EKS cluster will be created"
  type        = string
}

variable "cluster_version" {
  description = "The desired Kubernetes version for the EKS cluster"
  type        = string
}

variable "region" {
  description = "current AWS region"
  type        = string
  default     = "us-east-2"
}

variable "environment" {
  description = "current aws environment"
  type        = string
}

variable "ou_role_arn" {
  description = "current environment role arn"
  type        = string
}

variable "tags" {
  description = "A map of tags to apply to all resources"
  type        = map(string)
}

variable "public_subnet_ids" {
  description = "List of subnets for EKS cluster"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "List of subnets for EKS cluster"
  type        = list(string)
}
