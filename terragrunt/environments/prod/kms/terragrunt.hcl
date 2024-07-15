# environments/prod/kms/terragrunt.hcl

terraform {
  source = "git::git@github.com:Noise475/DevOps-Practice.git//terragrunt/modules/kms?ref=0.0.1"
}

include "root" {
  path   = find_in_parent_folders()
  expose = true
}

dependency "iam" {
  config_path = "../../../iam"
  mock_outputs = {
    ou_role_arn = "fake-role-arn"
  }
}

inputs = {
  role_arn = dependency.iam.outputs.ou_role_arn

  tags = {

  }
}