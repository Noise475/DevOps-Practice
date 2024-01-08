# modules/eks/main.tf

# EKS Cluster
resource "aws_eks_cluster" "terragrunt_cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster.arn
  vpc_config {
    subnet_ids = var.subnets
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy_attachment
  ]
}

# EKS Node Group
resource "aws_eks_node_group" "terragrunt_group" {
  cluster_name    = aws_eks_cluster.terragrunt_group.name
  node_group_name = "terragrunt_group_example"
  node_role_arn   = aws_iam_role.terragrunt_group.arn
  subnet_ids      = aws_subnet.terragrunt_group[*].id

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.example-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.example-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.example-AmazonEC2ContainerRegistryReadOnly,
  ]
}

output "kubeconfig" {
  value = aws_eks_cluster.terragrunt_cluster.kubeconfig[*].kubeconfig[*].raw_config
}
