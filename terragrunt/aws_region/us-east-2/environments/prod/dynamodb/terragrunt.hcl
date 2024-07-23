# us-east-2/environmentsprod/dynamodb/terragrunt.hcl

terraform {
  source = "git::https://github.com/Noise475/DevOps-Practice.git//terragrunt/modules/dynamodb?ref=0.0.1"
}

include "root" {
  path   = find_in_parent_folders()
  expose = true
}

dependency "s3" {
  config_path  = "../s3"
  skip_outputs = true
}

inputs = {
tags = include.root.inputs.tags
}
