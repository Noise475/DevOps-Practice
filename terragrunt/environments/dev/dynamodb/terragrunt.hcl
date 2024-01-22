# environments/dev/dynamodb/terragrunt.hcl

terraform {
  source = "../../../modules/dynamodb" #"git::git@github.com:Noise475/DevOps-Practice.git//terragrunt/modules/dynamodb?ref=0.0.0"
}

include "root" {
  path = find_in_parent_folders()
}
