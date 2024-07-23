# us-east-2/s3/terragrunt.hcl

terraform {
  source = "../modules/s3" #"git::https://github.com/Noise475/DevOps-Practice.git//terragrunt/modules/s3?ref=0.0.3"
}

include "root" {
  path   = find_in_parent_folders()
  expose = true
}

dependency "kms" {
  config_path = "../kms"

  mock_outputs = {
    s3_key_arn = "placeholder"
  }
}

inputs = {
  s3_key_arn = dependency.kms.outputs.s3_key_arn

  tags = merge(include.root.inputs.tags, { Org_ID = "${get_env("ENVIRONMENT")}", Environment = "${get_env("ENVIRONMENT")}" })
}
