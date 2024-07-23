# us-east-2/kms/terragrunt.hcl

terraform {
  source = "../modules/kms"#"git::https://github.com/Noise475/DevOps-Practice.git//terragrunt/modules/kms?ref=0.0.1"
}

include "root" {
  path   = find_in_parent_folders()
  expose = true
}

dependency "iam" {
  config_path = "../iam"
  mock_outputs = {
    ou_role_arn = "fake-role-arn"
  }
}

inputs = {
  role_arn = dependency.iam.outputs.ou_role_arn
  account_id = "590183659157"
  environment = "${get_env("ENVIRONMENT")}"

  tags = merge(include.root.inputs.tags, { Org_ID = "${get_env("ENVIRONMENT")}", Environment = "${get_env("ENVIRONMENT")}" })
}
