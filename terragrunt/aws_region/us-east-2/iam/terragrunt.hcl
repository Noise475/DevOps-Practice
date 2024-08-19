# us-east-2/iam/terragrunt.hcl

terraform {
  source = "../../../modules/iam" #"git::https://github.com/Noise475/DevOps-Practice.git//terragrunt/modules/iam?ref=0.0.4"
}

dependency "ou_creation" {
  config_path = "../ou_creation"
  mock_outputs = {
    current_ou_id = [""]
  }
}

include "root" {
  path   = find_in_parent_folders()
  expose = true
}

inputs = {
  region     = "us-east-2"
  Org_ID     = dependency.ou_creation.outputs.current_ou_id
  github_org = "Noise475"

  tags = include.root.inputs.tags
}
