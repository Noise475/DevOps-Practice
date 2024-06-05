# Terragrunt Usage

This folder treats this repo as a monorepo (containing helm/helmfile config within the same repo as terraform(terragrunt) config) and creates an eks-cluster with remote-state handled by S3 and state-locking within Dynamodb

## Terragrunt setup
``` shell
.
├── README.md
├── backend.tf
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
│       ├── terragrunt.hcl
│       └── vpc
│           └── terragrunt.hcl
├── generate-docs.sh
├── modules
│   ├── dynamodb
│   │   ├── dynamodb.tf
│   │   └── variables.tf
│   ├── eks
│   │   ├── eks.tf
│   │   ├── iam.tf
│   │   ├── inputs.tf
│   │   ├── policies
│   │   │   └── iam.json
│   │   └── variables.tf
│   ├── kms
│   │   ├── kms.tf
│   │   ├── outputs.tf
│   │   └── policies
│   │       ├── s3.json
│   │       └── subnet.json
│   ├── s3
│   │   ├── policies
│   │   │   └── dynamodb.json
│   │   ├── s3.tf
│   │   └── variables.tf
│   └── vpc
│       ├── nat_gateway.tf
│       ├── outputs.tf
│       ├── variables.tf
│       └── vpc.tf
├── provider.tf
└── terragrunt.hcl
```

### Terragrunt file setup
 Terragrunt files are held at multiple levels:
  1. The root of the `terragrunt` directory 
  2. Under each environment directory: 
     - `terragrunt/environments/dev`
     - `terragrunt/environments/staging`  
     - `terragrunt/environments/prod`
  3. Under **EACH** module being loading in the environment
     * `terragrunt/environments/<env_name>/<module_name>` 

## How to run commands
Terragrunt as a terraform wrapper is usually running terraform commands as a group. Practically this means:

`terragrunt plan` can be ran in each module folder which will deliver the same output as `terraform plan`, but can take into account your settings in your terragrunt.hcl (like provider/backend file configs).

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
Module documentation for terragrunt is generated using the `generate-docs.sh` script which requires `terraform-docs` to be installed

## Creating a key-pair
You may find that creating an rsa key directly results in too big a char set for AWS/Terraform to process(greater than 255 error). This can be overcome by using the cli to create a .pem file, then creating a public key off of that.

1. `aws ec2 create-key-pair --key-name eks_dev_key --query 'KeyMaterial' --output text > eks_dev_key.pem`

2. `ssh-keygen -y -f eks_server_key.pem > eks_server_key.pub`

You can reference the key directly in the /environments/<env-name>/vpc/terragrunt.hcl
```
inputs = {
  private_subnet_key_arn = dependency.kms.outputs.private_subnet_key_arn
  eks_public_key         = "ssh-rsa AAAAB3NzaC1yc2..."
  tags = {

  }
} 
```
