# modules/eks/main.tf

# EKS Clusters
resource "aws_eks_cluster" "terragrunt_cluster" {
  for_each = var.eks_clusters

  name     = each.value.name
  role_arn = each.value.role_arn

  vpc_config {
    subnet_ids = concat(each.value.public_subnet_ids, each.value.private_subnet_ids)
  }

  tags = each.value.tags
}


# Node Groups
resource "aws_eks_node_group" "terragrunt_group" {
  for_each = var.eks_node_groups

  cluster_name    = aws_eks_cluster.terragrunt_cluster[each.key].name
  node_group_name = each.value.node_group_name
  node_role_arn   = aws_iam_role.eks_node_instance_role.arn
  subnet_ids      = concat(each.value.public_subnet_ids, each.value.private_subnet_ids)

  scaling_config {
    desired_size = each.value.scaling_config.desired_size
    max_size     = each.value.scaling_config.max_size
    min_size     = each.value.scaling_config.min_size
  }

  update_config {
    max_unavailable = each.value.update_config.max_unavailable
  }

  depends_on = [
    aws_eks_cluster.terragrunt_cluster
  ]

  tags = each.value.tags
}
