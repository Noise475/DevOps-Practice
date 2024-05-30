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
  eks_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCxbli5xVGYpr6i1up8jvlpdxKeNcfjBnrEmq/nsBdU79oJpGTQVUlylavoJL9UMe/nCkfAaldAU7tRCz9MAIFwUx72ZHL2oIFx0blHHrT7/EAyZj9ADSsFn7vgJM+93oJkwU/VhO+njirKgVcrX+vRWdu8QVdh6Sl1gSeaeJBBBf4RoE5Q5HleKpULDJEN0CBApLcpskOhx751BSO09RMG0MHHT3kKcm8L7t+MUe8HYqb6vAVQY2TXr1MLjP1eOnhHaSGJZlV9w1/PWBAKhGwb+sZbtfXvYPepKJlBA6XZYGEcn+1EFEMJsUocugSSgZOcI5G7xWQnEWlNdYpbxpjEn3bIB7HuRSpDi2XoucmuGmZre3Hu2AlgsClDqK8Y5zF6Py4U8AgDn/Lqv/qv3Y/B8bEvDv1oE1s1yZGTLvUHDloToNsi6hMnSn8w8azk5FcEGt4g8Pyg4thSTIZdVR2RuxbS0kf9FLlSEhl24B2vFZTvbVLaOJr7TqpGKu/fTwwjlP/grw7vMmv4AWerwyaGITLK6dLktbZy16IsAHLYtt5qCPd/Nuqv3O877+1GXxDLoeAIEgPt0ZegP+3l/HZQgQ464hWWqG15HBHfxrt3W5rhOe3HhTBnzFjVGH13qrV2wgINPkN3B2+G1oBIpo2bqwqby5L+/M5uTudZiVDVoQ=="
  tags = {

  }
}
