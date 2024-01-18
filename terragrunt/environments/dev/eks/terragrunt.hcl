# environments/dev/vpc/terragrunt.hcl

terraform {
  source = "../../../modules/eks" #"git::git@github.com:Noise475/DevOps-Practice.git//terragrunt/modules/eks?ref=0.0.0"
}

include "vpc" {
  path = "../../../modules/vpc"
}

# dev-specific variables
inputs = {
  cluster_name    = "dev-eks-cluster"
  cluster_version = "1.28"
  vpc_id          = module.vpc.vpc_id
}
