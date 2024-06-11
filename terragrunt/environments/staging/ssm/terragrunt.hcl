# environments/staging/ssm/terragrunt.hcl

terraform {
  source = "../../../modules//ssm" #"git::git@github.com:Noise475/DevOps-Practice.git//terragrunt/modules/ssm?ref=0.0.0"
}


include "root" {
  path   = find_in_parent_folders()
  expose = true
}

dependency "iam" {
  config_path = "../../../iam"

  mock_outputs = {
    staging_role_arn = "placeholder"
    root_role_arn    = "placeholder"
  }
}

dependency "kms" {
  config_path = "../kms"

  mock_outputs = {
    ssm_key_arn = "placeholder"
  }
}

inputs = {
  staging_role_arn = dependency.iam.outputs.ou_role_arn
  root_role_arn    = dependency.iam.outputs.tf_role_arn
  ssm_key_arn      = dependency.kms.outputs.ssm_key_arn

  tags = {

  }
}
