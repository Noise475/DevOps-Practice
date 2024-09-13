# modules/eks/data.tf

# EKS Cluster Auth
data "aws_eks_cluster_auth" "terragrunt_cluster_auth" {
  for_each = var.eks_clusters

  name = aws_eks_cluster.terragrunt_cluster[each.key].name
}

data "aws_eks_cluster" "terragrunt_cluster" {
  for_each = var.eks_clusters

  name = aws_eks_cluster.terragrunt_cluster[each.key].name
}
