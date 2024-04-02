provider "aws" {
  region = "us-east-2"
  assume_role {
    role_arn = "${get_env("DEV_ROLE_ARN")}"
  }
}
