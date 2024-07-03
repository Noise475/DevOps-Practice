# terragrunt/ou_creation/terragrunt.hcl

terraform {
  source = "../modules/ou_creation" #"git::git@github.com:Noise475/DevOps-Practice.git//terragrunt/modules/ou_creation?ref=0.0.0"
}

include "root" {
  path   = find_in_parent_folders()
  expose = true
}

inputs = {
  ou_names = [
    for name in ["dev", "staging", "prod"] : {
      name = name
    }
  ]
  environment = "${get_env("ENVIRONMENT")}"
  region      = "${get_env("REGION")}"

  tags = {
    Terraform   = true
    Region      = "${get_env("REGION")}"
  }
}
