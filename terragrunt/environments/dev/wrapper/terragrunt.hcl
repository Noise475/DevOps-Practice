#  environment/dev/wrapper/terragrunt.hcl

dependency "ou_creation" {
  config_path = "../../../ou_creation"
}

dependency "kms" {
  config_path = "../kms"

  mock_outputs = {
    kms_master_key_id = "fake-kms-master-key-id"
  }
}

dependency "vpc" {
  config_path = "../vpc"
  mock_outputs = {
    vpc_id = "fake-vpc-id"
    subnets = []
  }
}