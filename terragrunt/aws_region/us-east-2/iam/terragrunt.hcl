# us-east-2/iam/terragrunt.hcl

terraform {
  source = "git::git@github.com:Noise475/DevOps-Practice.git//terragrunt/modules/iam?ref=0.0.0"
}

locals {
  environment = "${get_env("ENVIRONMENT")}"
}

dependency "ou_creation" {
  config_path = "../ou_creation"
  mock_outputs = {
    ou_ids        = { dev = "placeholder" }
    current_ou_id = "placeholder"
  }
}

include "root" {
  path   = find_in_parent_folders()
  expose = true
}

inputs = {
  environments = ["dev", "staging", "prod"]
  environment  = ["${local.environment}"]
  github_org   = "Noise475"
  org_ids      = dependency.ou_creation.outputs.ou_ids
  org_id       = dependency.ou_creation.outputs.ou_ids["${local.environment}"]


  tags = include.root.inputs.tags
}
