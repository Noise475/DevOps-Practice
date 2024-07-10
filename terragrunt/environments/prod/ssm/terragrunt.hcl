# environments/prod/ssm/terragrunt.hcl

terraform {
  source = "../../../modules//ssm" #"git::git@github.com:Noise475/DevOps-Practice.git//terragrunt/modules/ssm?ref=0.0.0"
}

dependency "iam" {
  config_path = "../../../iam"

  mock_outputs = {
    prod_role_arn = "placeholder"
  }
}

dependency "kms" {
  config_path = "../kms"

  mock_outputs = {
    ssm_key_arn = "placeholder"
  }
}


inputs = {
  prod_role_arn      = dependency.iam.outputs.ou_role_arn
  root_role_arn      = dependency.iam.outputs.tf_role_arn
  ssm_key_arn        = dependency.kms.outputs.ssm_key_arn
  sso_instance_arn   = dependency.iam.outputs.sso_instance_arn
  permission_set_arn = dependency.iam.outputs.permission_set_arn
  sso_group_id       = dependency.iam.outputs.sso_group_id
  account_id         = dependency.iam.outputs.account_id

  tags = {

  }
}
