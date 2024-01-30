# environments/dev/s3/terragrunt.hcl

terraform {
  source = "../../../modules//s3" #"git::git@github.com:Noise475/DevOps-Practice.git//terragrunt/modules/s3?ref=0.0.0"
}

include "root" {
  path = find_in_parent_folders()
}

dependency "wrapper" {
  config_path = "../wrapper"
}

inputs = {
  kms_master_key_id = dependency.kms.outputs.s3_key_id
}
