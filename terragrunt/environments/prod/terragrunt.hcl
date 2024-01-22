# environments/dev/terragrunt.hcl
include "root" {
  path = find_in_parent_folders()
}

# Terraform code source location
terraform {
  source = "../..//modules" #"git::git@github.com:Noise475/DevOps-Practice.git//terragrunt/modules?ref=0.0.0"
}

# Vars to be replaced
inputs = {
  environment = "prod"
}
