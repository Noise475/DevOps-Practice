# us-east-2/s3/terragrunt.hcl

terraform {
  source = "../../../../../modules/s3"#"git::https://github.com/Noise475/DevOps-Practice.git//terragrunt/modules/s3?ref=0.0.4"
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

dependency "iam" {
  config_path = "../../../iam"
}

inputs = {
  s3_key_arn  = dependency.kms.outputs.s3_key_arn
  tags = include.root.inputs.tags
}
