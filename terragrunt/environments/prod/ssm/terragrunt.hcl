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

inputs = {
  prod_role_arn = dependency.iam.outputs.ou_role_arn
}
