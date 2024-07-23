# us-east-2/environmentsstaging/eks/terragrunt.hcl

terraform {
  source = "git::https://github.com/Noise475/DevOps-Practice.git//terragrunt/modules/eks?ref=0.0.3"
}

include "root" {
  path   = find_in_parent_folders()
  expose = true
}

dependency "iam" {
  config_path = "../../../iam"
  mock_outputs = {
    ou_role_arn = "staging_role_arn"
  }
}

dependency "vpc" {
  config_path = "../vpc"
  mock_outputs = {
    vpc_id  = "fake-vpc-id"
    subnets = []
  }
}

# staging-specific variables
inputs = {
  cluster_name    = "staging-eks-cluster"
  cluster_version = "1.28"
  vpc_id          = dependency.vpc.outputs.vpc_id
  subnets         = dependency.vpc.outputs.subnets
  ou_role_arn     = dependency.iam.outputs.ou_role_arn

tags = include.root.inputs.tags
}
