# environments/dev/eks/terragrunt.hcl

terraform {
  source = "../../../modules//eks" #"git::git@github.com:Noise475/DevOps-Practice.git//terragrunt/modules/eks?ref=0.0.0"
}

include "root" {
  path = find_in_parent_folders()
}

dependency "vpc" {
  config_path = "../vpc"
  mock_outputs = {
    vpc_id = "fake-vpc-id"
    subnets = []
  }
}

# dev-specific variables
inputs = {
  cluster_name    = "dev-eks-cluster"
  cluster_version = "1.28"
  vpc_id          = dependency.vpc.outputs.vpc_id
  subnets         = dependency.vpc.outputs.subnets
}
