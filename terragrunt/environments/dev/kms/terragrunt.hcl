# environments/dev/kms/terragrunt.hcl

terraform {
  source = "../../../modules//kms" #"git::git@github.com:Noise475/DevOps-Practice.git//terragrunt/modules/kms?ref=0.0.0"
}

dependency "iam" {
  config_path = "../../../iam"
  mock_outputs = {
    ou_role_arn = "fake-role-arn"
  }
}

inputs = {
  role_arn = dependency.iam.outputs.ou_role_arn
}
