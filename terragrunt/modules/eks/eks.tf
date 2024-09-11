# modules/eks/main.tf
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# EKS Clusters
resource "aws_eks_cluster" "terragrunt_cluster" {
  for_each = var.eks_clusters

  name     = each.value.name
  role_arn = aws_iam_role.cluster_role.arn
  version  = each.value.version

  vpc_config {
    subnet_ids             = concat(each.value.public_subnet_ids, each.value.private_subnet_ids)
    security_group_ids     = [aws_security_group.eks_cluster_sg.id]
    endpoint_public_access = true
  }

  tags = each.value.tags
}

# Node Groups
resource "aws_eks_node_group" "node_group" {
  for_each = var.eks_node_groups

  cluster_name    = aws_eks_cluster.terragrunt_cluster[each.value.cluster_key].name
  node_group_name = each.value.node_group_name
  node_role_arn   = aws_iam_role.eks_node_instance_role.arn

  # Determine which subnets to use based on configuration
  subnet_ids = length(lookup(each.value, "public_subnet_ids", [])) > 0 ? each.value.public_subnet_ids : each.value.private_subnet_ids

  instance_types = each.value.instance_types

  remote_access {
    ec2_ssh_key               = each.value.eks_public_key
    source_security_group_ids = [aws_security_group.eks_node_sg.id]
  }

  scaling_config {
    desired_size = each.value.scaling_config.desired_size
    max_size     = each.value.scaling_config.max_size
    min_size     = each.value.scaling_config.min_size
  }

  update_config {
    max_unavailable = each.value.update_config.max_unavailable
  }

  depends_on = [
    aws_eks_cluster.terragrunt_cluster,
    aws_iam_role_policy_attachment.eks_worker_policies
  ]

  tags = var.tags
}
