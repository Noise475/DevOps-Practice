# environments/dev/kms/terragrunt.hcl

terraform {
  source = "../../../modules//kms" #"git::git@github.com:Noise475/DevOps-Practice.git//terragrunt/modules/kms?ref=0.0.0"
}

include "root" {
  path = find_in_parent_folders()
}

# inputs = {
#   s3_key_id = module.kms.s3_key_id
# }