module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = local.cluster_name
  cluster_version = "1.17"
  subnets = module.vpc.private_subnets

  tags = {
    Environment = "test"
    GithubRepo  = "DevOps-Practice"
    GithubOrg   = ""
  }

  vpc_id = module.vpc.vpc_id

  worker_groups = [
    {
      name                          = "k8-test-1"
      instance_type                 = "t2.small"
      additional_userdata           = "echo foo bar"
      asg_desired_capacity          = 2
      additional_security_group_ids = [aws_security_group.k8_mgmt_one.id]
    },
    {
      name                          = "k8-test-2"
      instance_type                 = "t2.small"
      additional_userdata           = "echo foo bar two"
      asg_desired_capacity          = 1
      additional_security_group_ids = [aws_security_group.k8_mgmt_two.id]

    }
  ]
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}
