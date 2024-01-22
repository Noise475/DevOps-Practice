# modules/eks/main.tf

# EKS Cluster
resource "aws_eks_cluster" "terragrunt_cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster.arn
  vpc_config {
    subnet_ids = [var.subnets]
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy_attachment
  ]
}

# EKS Cluster Auth (as data source)
data "aws_eks_cluster_auth" "terragrunt_cluster_auth" {
  name = aws_eks_cluster.terragrunt_cluster.name
}

# EKS Node Group
resource "aws_eks_node_group" "terragrunt_group" {
  cluster_name    = aws_eks_cluster.terragrunt_cluster.name
  node_group_name = "terragrunt_group_example"
  node_role_arn   = aws_iam_role.eks_cluster.arn
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

output "kubeconfig" {
  value = data.aws_eks_cluster_auth.terragrunt_cluster_auth[*].kubeconfig[*].raw_config
}
