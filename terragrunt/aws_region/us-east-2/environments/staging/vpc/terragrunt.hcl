2 # us-east-2/environmentsstaging/vpc/terragrunt.hcl

terraform {
  source = "git::https://github.com/Noise475/DevOps-Practice.git//terragrunt/modules/vpc?ref=0.0.4"
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
  cidr_block = "10.10.0.0/16"

  public_subnet_cidrs = [
    "10.10.1.0/24",
    "10.10.2.0/24",
    "10.10.3.0/24"
  ]

  private_subnet_cidrs = [
    "10.10.4.0/24",
    "10.10.5.0/24",
    "10.10.6.0/24"
  ]
  
  availability_zones = ["us-east-2a", "us-east-2b", "us-east-2c"]

  private_subnet_key_arn = dependency.kms.outputs.private_subnet_key_arn
  s3_key_arn             = dependency.kms.outputs.s3_key_arn
  eks_public_key         = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJFwbKx42wuvwdHbQF3PBAA41dr4o3wzKERlrsJ6Xytl"
  ou_role_arn            = dependency.iam.outputs.ou_role_arn

  tags                   = include.root.inputs.tags
}
