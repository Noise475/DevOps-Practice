# environments/staging/s3/terragrunt.hcl

terraform {
  source = "../../../modules//s3" #"git::git@github.com:Noise475/DevOps-Practice.git//terragrunt/modules/s3?ref=0.0.0"
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

  tags = {

  }
}
