# Terragrunt Usage

This folder treats this repo as a monorepo (containing terraform module config within the same repo as terragrunt config) and creates an eks-cluster with remote-state handled by S3 and state-locking within Dynamodb

I don't recommend monorepo style for your terraform modules if you'll be controlling versions by tagging; As you'll need to cut a new tag for the whole repo on every module update. I'll denote this within the repo by designating module updates as pre-release tags.

## Terragrunt setup
``` shell
.
├── README.md
├── assume-role.sh
├── environments
│   ├── dev
│   │   ├── dynamodb
│   │   │   └── terragrunt.hcl
│   │   ├── eks
│   │   │   └── terragrunt.hcl
│   │   ├── kms
│   │   │   └── terragrunt.hcl
│   │   ├── provider.tf
│   │   ├── s3
│   │   │   └── terragrunt.hcl
│   │   ├── ssm
│   │   │   └── terragrunt.hcl
│   │   ├── terragrunt.hcl
│   │   └── vpc
│   │       └── terragrunt.hcl
│   ├── prod
│   │   ├── dynamodb
│   │   │   └── terragrunt.hcl
│   │   ├── eks
│   │   │   └── terragrunt.hcl
│   │   ├── kms
│   │   │   └── terragrunt.hcl
│   │   ├── provider.tf
│   │   ├── s3
│   │   │   └── terragrunt.hcl
│   │   ├── ssm
│   │   │   └── terragrunt.hcl
│   │   ├── terragrunt.hcl
│   │   └── vpc
│   │       └── terragrunt.hcl
│   └── staging
│       ├── dynamodb
│       │   └── terragrunt.hcl
│       ├── eks
│       │   └── terragrunt.hcl
│       ├── kms
│       │   └── terragrunt.hcl
│       ├── provider.tf
│       ├── s3
│       │   └── terragrunt.hcl
│       ├── ssm
│       │   └── terragrunt.hcl
│       ├── terragrunt.hcl
│       └── vpc
│           └── terragrunt.hcl
├── generate-docs.sh
├── iam
│   └── terragrunt.hcl
├── initial-env-setup.sh
├── modules
│   ├── dynamodb
│   │   ├── README.md
│   │   ├── dynamodb.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── eks
│   │   ├── README.md
│   │   ├── data.tf
│   │   ├── eks.tf
│   │   ├── inputs.tf
│   │   ├── policies
│   │   │   └── iam.json
│   │   └── variables.tf
│   ├── iam
│   │   ├── README.md
│   │   ├── iam.tf
│   │   ├── output.tf
│   │   ├── policies
│   │   │   ├── assume-env-policy.json
│   │   │   ├── assume-tf-policy.json
│   │   │   ├── eks-policy.json
│   │   │   ├── ou-terraform-policy.json
│   │   │   ├── root-terraform-policy.json
│   │   │   └── terraform-state-policy.json
│   │   ├── sso.tf
│   │   └── variables.tf
│   ├── kms
│   │   ├── README.md
│   │   ├── kms.tf
│   │   ├── outputs.tf
│   │   ├── policies
│   │   │   └── kms-policy.json
│   │   └── variables.tf
│   ├── ou_creation
│   │   ├── README.md
│   │   ├── data.tf
│   │   ├── ou_creation.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── s3
│   │   ├── README.md
│   │   ├── policies
│   │   │   └── s3-policy.json
│   │   ├── s3.tf
│   │   └── variables.tf
│   ├── ssm
│   │   ├── README.md
│   │   ├── ssm.tf
│   │   └── variables.tf
│   └── vpc
│       ├── README.md
│       ├── nat_gateway.tf
│       ├── outputs.tf
│       ├── variables.tf
│       └── vpc.tf
├── ou_creation
│   └── terragrunt.hcl
└── terragrunt.hcl
```

### Terragrunt file setup
 terragrunt.hcl files are held at multiple levels:
  1. The root of the `terragrunt` directory 
  2. Under each environment directory: 
     - `terragrunt/environments/dev`
     - `terragrunt/environments/staging`  
     - `terragrunt/environments/prod`
  3. Under **EACH** module being loading in the environment
     * `terragrunt/environments/<env_name>/<module_name>` 

## Cloud Access
This example was built with AWS as the cloud provider in mind, but should work similarly with other providers suchs as azure and google cloud provided you update providers & respetive terraform code and configuration.

### Using SSO
The SSO config (Using IAM Identity Center) Will need to be created manually in AWS Account. After initial setup via console, it is possible to add terraform configuration for permission sets, and account and group assignments. An example can be found below.

To gain access to a user created via SSO you'll need to use the `aws configure sso` command; follow prompts - when it asks for 
an SSO URL it can be found on the identity center dashboard - search for *Sign-in URL for IAM users in this account* and copy the link there.

```
resource "aws_ssoadmin_permission_set" "devops_permission_set" {
  instance_arn = data.aws_ssoadmin_instances.example.arns[0] # SSO instance ARN
  name         = "DevOpsPermissionSet"
  description  = "Permission set for DevOps team"
  session_duration = "PT8H"

  tags = {
    "Environment" = "Dev"
  }
...
}


resource "aws_ssoadmin_account_assignment" "devops_assignment" {
  instance_arn       = data.aws_ssoadmin_instances.example.arns[0]
  permission_set_arn = aws_ssoadmin_permission_set.devops_permission_set.arn
  principal_id       = "devops-group-id" # This should be the ID of the DevOps group
  principal_type     = "GROUP"
  target_id          = "aws-account-id" # The AWS account ID to assign the permissions to
  target_type        = "AWS_ACCOUNT"
}
```

## How to run commands
Terragrunt as a terraform wrapper is usually running terraform commands as a group. Practically this means:

`terragrunt plan` can be ran in each terragrunt module folder which will deliver the same output as `terraform plan`, but can take into account your settings in your terragrunt.hcl (like provider/backend file configs).

```
INFO[0000] Downloading Terraform configurations from file:///Users/guestadmin/git/DevOps-Practice/terragrunt/modules into /Users/guestadmin/git/DevOps-Practice/terragrunt/environments/dev/vpc/.terragrunt-cache/Sc8-jha5f51vUf2NSfZAz4EYlHE/xyQE6GfL4jWSqLyKZKDrYOybgfE 

Initializing the backend...

Initializing provider plugins...
- Reusing previous version of hashicorp/aws from the dependency lock file
- Using previously-installed hashicorp/aws v5.31.0

Terraform has been successfully initialized!

...

Terraform used the selected providers to generate the following execution
plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # aws_instance.eks_nat_instance_a will be created
  + resource "aws_instance" "eks_nat_instance_a" {
      + ami                                  = "ami-0c55b159cbfafe1f0"
+ vpc_id  = (known after apply)
...
```

`terragrunt run-all <command>` can be ran in the directory containing your root terragrunt.hcl. This will run the targeted command `terraform <command>` against all submodules from the root; for example, running `terragrunt run-all plan` in `environments/dev`
will output the results of `terraform plan` for the following modules:
- dynamodb
- eks
- kms
- s3
- vpc

## Terraform-docs
Module documentation for terragrunt is generated using the `generate-docs.sh` script which requires `terraform-docs` to be installed. 

using homebrew:
`brew install terraform-docs`

## Creating a key-pair
You may find that creating an rsa key directly results in too big a char set for AWS/Terraform to process(greater than 255 error). This can be overcome by using the ed25519 standard to create a key.

1. `ssh-keygen -t ed25519 -f eks_prod_key -N ""`

You can reference the key directly in the /environments/<env-name>/vpc/terragrunt.hcl
```
inputs = {
  private_subnet_key_arn = dependency.kms.outputs.private_subnet_key_arn
  eks_public_key         = "ssh-ed25519 AAAAC3NzaC1lZ..."
  tags = {

  }
} 
```
