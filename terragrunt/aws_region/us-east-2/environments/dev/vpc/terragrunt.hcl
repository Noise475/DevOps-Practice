# us-east-2/environmentsdev/vpc/terragrunt.hcl

terraform {
  source = "git::https://github.com/Noise475/DevOps-Practice.git//terragrunt/modules/vpc?ref=0.0.0"
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

  mock_outputs_merge_strategy_with_state = "shallow"
}

inputs = {
  cidr_block = "10.20.0.0/16"

  public_subnet_cidrs = {
    a = "10.20.1.0/24"
    b = "10.20.2.0/24"
    c = "10.20.3.0/24"
  }

  private_subnet_cidrs = {
    a = "10.20.4.0/24"
  }

  availability_zones = {
    a = "us-east-2a"
    b = "us-east-2b"
    c = "us-east-2c"
  }

  private_subnet_key_arn = dependency.kms.outputs.private_subnet_key_arn
  s3_key_arn             = dependency.kms.outputs.s3_key_arn
  eks_public_key         = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB+8GOSiLmugMq86ptAW9hDToexMingO2tiatTaJAwY8"
  ou_role_name           = "dev"
  role_arn               = dependency.iam.outputs.ou_role_arns["dev"]

  tags = include.root.inputs.tags
}
