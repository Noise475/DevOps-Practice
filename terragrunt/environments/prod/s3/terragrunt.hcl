# environments/prod/s3/terragrunt.hcl

terraform {
  source = "../../../modules//s3" #"git::git@github.com:Noise475/DevOps-Practice.git//terragrunt/modules/s3?ref=0.0.0"
}

include "root" {
  path = find_in_parent_folders()
}

dependency "kms" {
  config_path = "../kms"

  mock_outputs = {
    kms_master_key_id = "fake-kms-master-key-id"
  }
}

inputs = {
  kms_master_key_id = dependency.kms.outputs.s3_key_id
}