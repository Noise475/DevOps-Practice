# modules/eks/main.tf

# EKS Cluster
resource "aws_eks_cluster" "terragrunt_cluster" {
  name     = var.cluster_name
  role_arn = var.ou_role_arn
  vpc_config {
    subnet_ids = [var.subnets]
  }
}

# EKS Node Group
resource "aws_eks_node_group" "terragrunt_group" {
  cluster_name    = aws_eks_cluster.terragrunt_cluster.name
  node_group_name = "terragrunt_group_example"
  node_role_arn   = var.ou_role_arn
  subnet_ids      = [var.subnets]

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }
}
