# Terragrunt Usage

This folder treats this repo as a monorepo (containing helm/helmfile config within this same repo) and creates
an eks-cluster with remote-state files handled by S3 and remote-state-locking within Dynamodb

## File setup
``` shell
terragrunt
├── environments
│   ├── dev
│   │   └── terragrunt.hcl
│   ├── prod
│   │   └── terragrunt.hcl
│   └── staging
│       └── terragrunt.hcl
├── modules
│   ├── dynamodb
│   │   ├── dynamodb.tf
│   │   └── variables.tf
│   ├── eks
│   │   ├── eks.tf
│   │   ├── iam.tf
│   │   ├── policies
│   │   │   └── iam.json
│   │   └── variables.tf
│   ├── kms
│   │   ├── kms.tf
│   │   └── policies
│   │       ├── s3.json
│   │       └── subnet.json
│   ├── s3
│   │   ├── policies
│   │   │   └── iam.json
│   │   ├── s3.tf
│   │   └── variables.tf
│   └── vpc
│       └── vpc.tf
└── terragrunt.hcl
```