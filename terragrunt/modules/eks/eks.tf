# modules/eks/main.tf

# EKS Cluster
resource "aws_eks_cluster" "terragrunt_cluster" {
  name     = var.cluster_name
  role_arn = var.ou_role_arn

  vpc_config {
    subnet_ids = concat(var.public_subnet_ids, var.private_subnet_ids)
  }

  tags = var.tags
}

# EKS Node Group
resource "aws_eks_node_group" "terragrunt_group" {
  cluster_name    = aws_eks_cluster.terragrunt_cluster.name
  node_group_name = "terragrunt_group_example"
  node_role_arn   = aws_iam_role.eks_node_instance_role.arn
  subnet_ids      = concat(var.public_subnet_ids, var.private_subnet_ids)

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

  depends_on = [
  aws_eks_cluster.terragrunt_cluster]

  tags = var.tags
}
