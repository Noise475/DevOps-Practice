# us-east-2/ou_creation/terragrunt.hcl

terraform {
  source = "git::https://github.com/Noise475/DevOps-Practice.git//terragrunt/modules/ou_creation?ref=0.0.3"
}

include "root" {
  path   = find_in_parent_folders()
  expose = true
}

inputs = {
  ou_names = [
    for name in ["dev", "staging", "prod"] : {
      name = name
    }
  ]
  environment = "${get_env("ENVIRONMENT")}"
  region      = "us-east-2"

  tags = merge(include.root.inputs.tags, { Org_ID = "${get_env("ENVIRONMENT")}", Environment = "${get_env("ENVIRONMENT")}" })
}
