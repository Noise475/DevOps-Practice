# environments/dev/vpc/terragrunt.hcl

terraform {
  source = "../../../modules//vpc" #"git::git@github.com:Noise475/DevOps-Practice.git//terragrunt/modules/s3?ref=0.0.0"
}

include "root" {
  path   = find_in_parent_folders()
  expose = true
}

dependency "kms" {
  config_path = "../kms"
  mock_outputs = {
    private_subnet_key_arn = "placeholder"
  }
}


inputs = {
  private_subnet_key_arn = dependency.kms.outputs.private_subnet_key_arn
  eks_public_key         = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCkYKsVpMnu0lTvkR04ZhjpM4MOsMEHU5qVpU6nbuSyDi7EtwAsg9QRu8vA9W8lem6QOJfqvq7sGryE9gQ14uYU5rMHxWi/nJbPJ8daeTI86+vUV7hj23tqolftruGkfvGxXU+en8w1vVIimPb/ULh+WoeifDONczeFUR4dERJIGfOoT9sDmcpK8hnwzU4zM41ucREkgWLY5C2jR91jNLfyRfygPXRmUcPNQBqK0XHTesds8QBfzJCWTcor4GryGb/Eaovi6odfsOq6WT1O7YVhu651k+643MSLMmIopPg5iNcj1NS0hxbMwzyxeyX3m+S8vmPiHkg6pNp2HWiZDzsV"
  tags = {

  }
}
