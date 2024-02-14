# terragrunt/ou_creation/terragrunt.hcl

terraform {
  source = "../../../modules/iam" #"git::git@github.com:Noise475/DevOps-Practice.git//terragrunt/modules/iam?ref=0.0.0"
}

inputs = {
  environment = "dev"
  region = "us-east-2"
}
