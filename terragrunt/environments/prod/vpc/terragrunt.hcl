# environments/prod/vpc/terragrunt.hcl

terraform {
  source = "git::git@github.com:Noise475/DevOps-Practice.git//terragrunt/modules/s3?ref=0.0.1"
}

include "root" {
  path   = find_in_parent_folders()
  expose = true
}

dependency "kms" {
  config_path = "../kms"

  mock_outputs = {
    private_subnet_key_arn = "placeholder"
    s3_key_arn = "placeholder"
  }
}
inputs = {
  private_subnet_key_arn = dependency.kms.outputs.private_subnet_key_arn
  s3_key_arn = dependency.kms.outputs.s3_key_arn
  eks_public_key         = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICKRGhfxo4sqmtkxodQuigEFWFgMIEA19B1uFNDheKdJ"
}
