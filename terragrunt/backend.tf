# Generated by Terragrunt. Sig: nIlQXj57tbuaRZEa
terraform {
  backend "s3" {
    bucket         = "global-remote-state-terraform-bucket"
    dynamodb_table = "terraform-state-lock-table"
    encrypt        = true
    key            = "./terraform.tfstate"
    region         = "us-east-2"
  }
}