# us-east-2/environmentsdev/eks/terragrunt.hcl

terraform {
  source = "../../../../../modules/eks" #"git::https://github.com/Noise475/DevOps-Practice.git//terragrunt/modules/eks?ref=0.0.4"
}

include "root" {
  path   = find_in_parent_folders()
  expose = true
}

dependency "iam" {
  config_path = "../../../iam"
  mock_outputs = {
    ou_role_arn = "dev_role_arn"
  }
}

dependency "vpc" {
  config_path = "../vpc"
  mock_outputs = {
    vpc_id             = "dev-vpc-id"
    public_subnet_ids  = ["placeholder"]
    private_subnet_ids = ["placeholder"]
  }
}

# dev-specific variables
inputs = {
  cluster_name    = "dev-eks-cluster"
  cluster_version = "1.30"

  public_subnet_ids  = dependency.vpc.outputs.public_subnet_ids
  private_subnet_ids = dependency.vpc.outputs.private_subnet_ids

  vpc_id      = dependency.vpc.outputs.vpc_id
  ou_role_arn = dependency.iam.outputs.ou_role_arn

  tags = include.root.inputs.tags
}
