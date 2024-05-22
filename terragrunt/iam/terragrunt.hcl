# terragrunt/iam/terragrunt.hcl

terraform {
  source = "../modules/iam" #"git::git@github.com:Noise475/DevOps-Practice.git//terragrunt/modules/iam?ref=0.0.0"
}

dependency "ou_creation" {
  config_path = "../ou_creation"
  mock_outputs = {
    current_ou_id = [""]
  }
}

include "root" {
  path   = find_in_parent_folders()
  expose = true
}

inputs = {
  environment  = get_env("ENVIRONMENT")
  environments = ["dev", "staging"]
  region       = get_env("REGION")
  account_id   = get_env("ACCOUNT_ID")
  org_id       = dependency.ou_creation.outputs.current_ou_id
  # sso_instance_arn   = get_env("SSO_INSTANCE_ARN")
  # sso_group_id       = get_env("SSO_GROUP_ID")
  # permission_set_arn = get_env("PERMISSION_SET_ARN")
}
