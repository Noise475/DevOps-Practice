# us-east-2/ou_creation/terragrunt.hcl

terraform {
  source = "git::https://github.com/Noise475/DevOps-Practice.git//terragrunt/modules/ou_creation?ref=0.0.4"
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

  tags = include.root.inputs.tags
}
