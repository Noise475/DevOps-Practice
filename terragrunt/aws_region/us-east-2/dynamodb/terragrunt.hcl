# us-east-2/dynamodb/terragrunt.hcl

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
  environment = "${get_env("ENVIRONMENT")}"

  tags = merge(include.root.inputs.tags, { Region = "us-east-2", Org_ID = "${get_env("ENVIRONMENT")}", Environment = "${get_env("ENVIRONMENT")}" })
}
