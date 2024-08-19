# environments/dev/kms/terragrunt.hcl

terraform {
  source = "../../../../../modules/kms" #"git::https://github.com/Noise475/DevOps-Practice.git//terragrunt/modules/kms?ref=0.0.4"
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

  mock_outputs_merge_strategy_with_state = "shallow"
}

inputs = {
  tags = include.root.inputs.tags
}
