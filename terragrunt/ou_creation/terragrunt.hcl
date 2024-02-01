# terragrunt/ou_creation/terragrunt.hcl

terraform {
  source = "../modules" #"git::git@github.com:Noise475/DevOps-Practice.git//terragrunt/modules/ou_creation?ref=0.0.0"
}

include "root" {
  path = find_in_parent_folders()
  expose = true
}

inputs = {
  ou_names = ["dev", "staging", "prod"]
  ou       = basename(find_in_parent_folders())
}
