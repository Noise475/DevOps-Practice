# environments/prod/terragrunt.hcl

terraform {
  source = "git::git@github.com:Noise475/DevOps-Practice.git?ref=0.0.1"
}

include "root" {
  path = find_in_parent_folders()
}

inputs = {
  environment = "prod"
}
