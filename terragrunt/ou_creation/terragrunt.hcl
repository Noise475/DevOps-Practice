# terragrunt/ou_creation/terragrunt.hcl

terraform {
  source = "../ou_creation" #"git::git@github.com:Noise475/DevOps-Practice.git//terragrunt/modules/ou_creation?ref=0.0.0"
}

include "root" {
  path = find_in_parent_folders()
}

inputs = {
  ou_names = [sdlc, prod]
}
