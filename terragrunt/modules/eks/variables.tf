# modules/eks/variables.tf

# Cluster config map
variable "eks_clusters" {
  description = "Map of EKS clusters"
  type = map(object({
    name               = string
    role_arn           = string
    public_subnet_ids  = list(string)
    private_subnet_ids = list(string)
    version            = string
    tags               = map(string)
  }))
}

# Node group config map
variable "eks_node_groups" {
  description = "Map of EKS node groups"
  type = map(object({
    node_group_name    = string
    public_subnet_ids  = list(string)
    private_subnet_ids = list(string)
    version            = string
    scaling_config = object({
      desired_size = number
      max_size     = number
      min_size     = number
    })
    update_config = object({
      max_unavailable = number
    })
    tags = map(string)
  }))
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
