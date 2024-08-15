# us-east-2/environmentsdev/vpc/terragrunt.hcl

terraform {
  source = "../../../../../modules/vpc" #"git::https://github.com/Noise475/DevOps-Practice.git//terragrunt/modules/vpc?ref=0.0.4"
}

include "root" {
  path   = find_in_parent_folders()
  expose = true
}

dependency "kms" {
  config_path = "../kms"
  mock_outputs = {
    private_subnet_key_arn = "placeholder"
    s3_key_arn             = "placeholder"
  }
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
    b = "10.20.5.0/24"
    c = "10.20.6.0/24"
  }

  availability_zones = { 
    a = "us-east-2a"
    b = "us-east-2b"
    c = "us-east-2c"
  }

  private_subnet_key_arn = dependency.kms.outputs.private_subnet_key_arn
  s3_key_arn             = dependency.kms.outputs.s3_key_arn
  eks_public_key         = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB+8GOSiLmugMq86ptAW9hDToexMingO2tiatTaJAwY8"

  tags = include.root.inputs.tags
}
