# us-east-2/s3/terragrunt.hcl

terraform {
  source = "git::https://github.com/Noise475/DevOps-Practice.git//terragrunt/modules/s3?ref=0.0.0"
}

include "root" {
  path   = find_in_parent_folders()
  expose = true
}

dependency "kms" {
  config_path = "../kms"

  mock_outputs = {
    s3_key_arn = "placeholder"
  }

  mock_outputs_merge_strategy_with_state = "shallow"
}

dependency "iam" {
  config_path = "../../../iam"

  mock_outputs = {
    ou_role_arn = "placeholder"
  }

  mock_outputs_merge_strategy_with_state = "shallow"
}

inputs = {
  s3_key_arn = dependency.kms.outputs.s3_key_arn
  role_arn   = dependency.iam.outputs.ou_role_arn
  tags       = include.root.inputs.tags
}
