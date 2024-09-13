# environments/prod/ssm/terragrunt.hcl

terraform {
  source = "git::git@github.com:Noise475/DevOps-Practice.git//terragrunt/modules/ssm?ref=0.0.0"
}

include "root" {
  path   = find_in_parent_folders()
  expose = true
}

dependency "iam" {
  config_path = "../../../iam"

  mock_outputs = {
    ou_role_arns  = { prod = "placeholder" }
    root_role_arn = "placeholder"
  }

  mock_outputs_merge_strategy_with_state = "shallow"
}

dependency "kms" {
  config_path = "../kms"

  mock_outputs = {
    ssm_key_arn = "placeholder"
  }

  mock_outputs_merge_strategy_with_state = "shallow"
}

inputs = {
  role_arn           = dependency.iam.outputs.ou_role_arns["prod"]
  root_role_arn      = dependency.iam.outputs.tf_role_arn
  ssm_key_arn        = dependency.kms.outputs.ssm_key_arn
  sso_instance_arn   = dependency.iam.outputs.sso_instance_arn
  permission_set_arn = dependency.iam.outputs.permission_set_arn
  sso_group_id       = dependency.iam.outputs.sso_group_id
  account_id         = dependency.iam.outputs.account_id

  tags = include.root.inputs.tags
}
