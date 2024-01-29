# modules/eks/data.tf

# EKS Cluster Auth
data "aws_eks_cluster_auth" "terragrunt_cluster_auth" {
  name = aws_eks_cluster.terragrunt_cluster.name
}

data "aws_eks_cluster" "terragrunt_cluster" {
  name = aws_eks_cluster.terragrunt_cluster.name
}
