# us-east-2/ou_creation/terragrunt.hcl

terraform {
  source = "git::git@github.com:Noise475/DevOps-Practice.git//terragrunt/modules/ou_creation?ref=0.0.1"
}

include "root" {
  path   = find_in_parent_folders()
  expose = true
}

locals {
  ou_names = {
    dev     = "dev"
    staging = "staging"
    prod    = "prod"
  }
}

inputs = {
  ou_names = local.ou_names

  tags = include.root.inputs.tags


}
