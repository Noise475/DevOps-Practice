# us-east-2/environmentsstaging/vpc/terragrunt.hcl

terraform {
  source = "git::git@github.com:Noise475/DevOps-Practice.git//terragrunt/modules/vpc?ref=0.0.0"
}

include "root" {
  path   = find_in_parent_folders()
  expose = true
}

dependency "iam" {
  config_path = "../../../iam"

  mock_outputs = {
    ou_role_arns = ["placeholder"]
  }

  mock_outputs_merge_strategy_with_state = "shallow"
}


dependency "kms" {
  config_path = "../kms"

  mock_outputs = {
    private_subnet_key_arn = "placeholder"
    s3_key_arn             = "placeholder"

  }
}

inputs = {
  cidr_block = "10.10.0.0/16"

  public_subnet_cidrs = {
    a = "10.10.1.0/24",
    b = "10.10.2.0/24",
    c = "10.10.3.0/24"
  }

  private_subnet_cidrs = {
    a = "10.10.4.0/24"
  }

  availability_zones = {
    a = "us-east-2a",
    b = "us-east-2b",
    c = "us-east-2c"
  }

  private_subnet_key_arn = dependency.kms.outputs.private_subnet_key_arn
  s3_key_arn             = dependency.kms.outputs.s3_key_arn
  eks_public_key         = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJFwbKx42wuvwdHbQF3PBAA41dr4o3wzKERlrsJ6Xytl"
  ou_role_name           = "staging"
  role_arn               = dependency.iam.outputs.ou_role_arns["staging"]

  tags = include.root.inputs.tags
}
