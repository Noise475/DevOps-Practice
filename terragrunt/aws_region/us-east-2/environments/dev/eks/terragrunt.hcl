# us-east-2/environments/dev/eks/terragrunt.hcl

terraform {
  source = "../../../../../modules/eks" #"git::git@github.com:Noise475/DevOps-Practice.git//terragrunt/modules/eks?ref=0.0.0"
}


include "root" {
  path   = find_in_parent_folders()
  expose = true
}

dependency "iam" {
  config_path = "../../../iam"
  mock_outputs = {
    ou_role_arns = { dev = "placeholder" }
  }
}

dependency "vpc" {
  config_path = "../vpc"

  mock_outputs = {
    vpc_id             = "dev-vpc-id"
    vpc_cidr           = "placeholder"
    eks_public_key     = "placeholder"
    public_subnet_ids  = ["100.1.1.0/16"]
    private_subnet_ids = ["100.10.1.0/16"]
  }

  mock_outputs_merge_strategy_with_state = "shallow"
}

# dev-specific variables
inputs = {
  cluster_name = "dev-eks-cluster"
  vpc_id       = dependency.vpc.outputs.vpc_id
  vpc_cidr     = dependency.vpc.outputs.vpc_cidr
  role_arn     = dependency.iam.outputs.ou_role_arns["dev"]

  eks_clusters = {
    "dev" = {
      name               = "dev-cluster"
      public_subnet_ids  = dependency.vpc.outputs.public_subnet_ids
      private_subnet_ids = dependency.vpc.outputs.private_subnet_ids
      version            = "1.30"
      tags               = include.root.inputs.tags
    }
  }

  eks_node_groups = {
    "public" = {
      cluster_key       = "dev"
      node_group_name   = "dev-public-node-group"
      eks_public_key    = dependency.vpc.outputs.eks_public_key
      instance_types    = ["t3.small"]
      public_subnet_ids = dependency.vpc.outputs.public_subnet_ids
      scaling_config = {
        desired_size = 2
        max_size     = 3
        min_size     = 1
      }
      update_config = {
        max_unavailable = 1
      }

      tags = include.root.inputs.tags
    }

    "private" = {
      cluster_key        = "dev"
      node_group_name    = "dev-private-node-group"
      eks_public_key     = dependency.vpc.outputs.eks_public_key
      instance_types     = ["t3.medium"]
      private_subnet_ids = dependency.vpc.outputs.private_subnet_ids
      scaling_config = {
        desired_size = 2
        max_size     = 4
        min_size     = 1
      }
      update_config = {
        max_unavailable = 1
      }

      tags = include.root.inputs.tags
    }
  }

  tags = include.root.inputs.tags
}