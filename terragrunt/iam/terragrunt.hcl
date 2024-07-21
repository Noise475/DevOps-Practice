# terragrunt/iam/terragrunt.hcl

terraform {
  source = "../modules/iam"#"git::https://github.com/Noise475/DevOps-Practice.git//terragrunt/modules/iam?ref=0.0.1"
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
  environment  = "${get_env("ENVIRONMENT")}"
  environments = ["dev", "staging", "prod"]
  region       = "us-east-2"
  account_id   = "590183659157"
  Org_ID       = dependency.ou_creation.outputs.current_ou_id
  github_org   = "Noise475"
  table_name   = "root-terraform-lock-table"

  tags = {
    Terraform = true
    Region    = "us-east-2"
  }
}
