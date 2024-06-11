# environments/prod/dynamodb/terragrunt.hcl

terraform {
  source = "../../../modules/dynamodb" #"git::git@github.com:Noise475/DevOps-Practice.git//terragrunt/modules/dynamodb?ref=0.0.0"
}

dependency "s3" {
  config_path  = "../s3"
  skip_outputs = true
}

include "root" {
  path   = find_in_parent_folders()
  expose = true
}

inputs = {
  tags = {

  }
}
