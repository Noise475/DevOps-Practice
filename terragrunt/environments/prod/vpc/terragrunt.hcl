# environments/prod/vpc/terragrunt.hcl

terraform {
  source = "../../../modules//vpc" #"git::git@github.com:Noise475/DevOps-Practice.git//terragrunt/modules/s3?ref=0.0.0"
}

include "root" {
  path = find_in_parent_folders()
}

locals {
  key_name = "prod-${md5("prod_key_name_string")}"
}

inputs = {
  key_name = local.key_name
}
