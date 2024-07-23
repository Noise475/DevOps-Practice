# us-east-2/environmentsstaging/dynamodb/terragrunt.hcl

terraform {
  source = "git::https://github.com/Noise475/DevOps-Practice.git//terragrunt/modules/dynamodb?ref=0.0.3"
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
tags = include.root.inputs.tags
}
