# us-east-2/dynamodb/terragrunt.hcl

terraform {
  source = "git::git@github.com:Noise475/DevOps-Practice.git//terragrunt/modules/dynamodb?ref=0.0.1"
}

include "root" {
  path   = find_in_parent_folders()
  expose = true
}

inputs = {
  tags = include.root.inputs.tags
}
