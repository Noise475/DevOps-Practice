# environments/dev/kms/terragrunt.hcl

terraform {
  source = "../../../modules//kms" #"git::git@github.com:Noise475/DevOps-Practice.git//terragrunt/modules/kms?ref=0.0.0"
}

dependency "ou_creation" {
  config_path = "../../../ou_creation"
  mock_outputs = {
    ou_role_arn = "fake-role-arn"
  }
}

inputs = {
  role_arn = dependency.ou_creation.outputs.ou_role_arn
}
