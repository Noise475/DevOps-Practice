provider "aws" {
  region = local.region
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "X.X.X"  # Replace with the desired version

  cluster_name = "my-eks-cluster"
  subnets      = module.vpc.private_subnets
}

