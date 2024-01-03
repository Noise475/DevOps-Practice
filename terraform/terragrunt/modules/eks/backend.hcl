remote_state {
  backend = "s3"
  config = {
    bucket         = "terraform-state-bucket"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = local.region
    encrypt        = true
    dynamodb_table = "terraform-state-lock-table"
    access_key     = ""
    secret_key     = ""
  }
}

