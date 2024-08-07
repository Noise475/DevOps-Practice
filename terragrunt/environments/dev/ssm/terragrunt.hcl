# environments/dev/ssm/terragrunt.hcl

terraform {
  source = "git::https://github.com/Noise475/DevOps-Practice.git//terragrunt/modules/ssm?ref=0.0.1"
}

include "root" {
  path   = find_in_parent_folders()
  expose = true
}

dependency "iam" {
  config_path = "../../../iam"

  mock_outputs = {
    dev_role_arn  = "placeholder"
    root_role_arn = "placeholder"
  }
}

dependency "kms" {
  config_path = "../kms"

  mock_outputs = {
    ssm_key_arn = "placeholder"
  }
}

inputs = {
  dev_role_arn       = dependency.iam.outputs.ou_role_arn
  root_role_arn      = dependency.iam.outputs.tf_role_arn
  ssm_key_arn        = dependency.kms.outputs.ssm_key_arn
  sso_instance_arn   = dependency.iam.outputs.sso_instance_arn
  permission_set_arn = dependency.iam.outputs.permission_set_arn
  sso_group_id       = dependency.iam.outputs.sso_group_id
  account_id         = dependency.iam.outputs.account_id

  tags = {

  }
}
