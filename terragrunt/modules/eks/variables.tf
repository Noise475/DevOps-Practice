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
  type = string
  default = "us-east-2"
}

variable "environment" {
  description = "current aws environment"
  type = string
}
