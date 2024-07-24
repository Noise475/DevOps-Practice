# us-east-2/s3/terragrunt.hcl

terraform {
  source = "git::https://github.com/Noise475/DevOps-Practice.git//terragrunt/modules/s3?ref=0.0.3"
}

include "root" {
  path   = find_in_parent_folders()
  expose = true
}

dependency "kms" {
  config_path = "../environments/${get_env("ENVIRONMENT")}/kms"

  mock_outputs = {
    s3_key_arn = "placeholder"
  }
}

inputs = {
  s3_key_arn  = dependency.kms.outputs.s3_key_arn
  environment = "${get_env("ENVIRONMENT")}"

  tags = merge(include.root.inputs.tags, { Region = "us-east-2", Org_ID = "${get_env("ENVIRONMENT")}", Environment = "${get_env("ENVIRONMENT")}" })
}
