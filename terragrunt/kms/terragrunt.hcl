# terragrunt/kms/terragrunt.hcl

terraform {
  source = "../modules/kms" #"git::git@github.com:Noise475/DevOps-Practice.git//terragrunt/modules/kms?ref=0.0.0"
}

dependency "ou_creation" {
  config_path  = "../ou_creation"
  skip_outputs = true
}

dependency "iam" {
  config_path = "../iam"
  mock_outputs = {
    ou_role_arn = "PLACEHOLDER"
  }
}

include "root" {
  path   = find_in_parent_folders()
  expose = true
}

inputs = {
  environment = get_env("ENVIRONMENT")
  region      = get_env("REGION")
  account_id  = get_env("ACCOUNT_ID")
  role_arn    = dependency.iam.outputs.ou_role_arn
}
