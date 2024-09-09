# modules/eks/variables.tf

variable "account_id" {
  description = "AWS Account ID"
  type        = string
}

# Cluster config map
variable "eks_clusters" {
  description = "Map of EKS clusters"
  type = map(object({
    name               = string
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
    cluster_key        = string
    eks_public_key     = string
    instance_types     = list(string)
    node_group_name    = string
    public_subnet_ids  = optional(list(string), [])
    private_subnet_ids = optional(list(string), [])
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

variable "environment" {
  description = "current aws environment"
  type        = string
}

variable "region" {
  description = "current AWS region"
  type        = string
  default     = "us-east-2"
}

variable "role_arn" {
  description = "AWS IAM role ARN"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "tags" {
  description = "A map of tags to apply to eks resources"
  type        = map(string)
}
