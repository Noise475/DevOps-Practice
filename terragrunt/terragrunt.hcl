# terragrunt.hcl

terraform {
  source =  "./modules" #"git::git@github.com:Noise475/DevOps-Practice.git/terragrunt//modules`?ref=0.0.0"
}

# Include the input values to use for the variables of the module.
inputs = {
  tags = {
    Terraform = "true"
  }
}
