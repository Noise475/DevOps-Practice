# environments/dev/s3/terragrunt.hcl

terraform {
  source = "../../../modules/s3" #"git::git@github.com:Noise475/DevOps-Practice.git//terragrunt/modules/s3?ref=0.0.0"
}
