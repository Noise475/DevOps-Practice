# Terraform

This folder represents an example of using terraform to build out 
an auto-scaled, load balanced set of EC2 instances.<br> 

To create the example in AWS: 

1. Create a credentials file in `~/.aws/credentials`. Replace the `<>` with your credentials. 
```shell script
[default]
aws_access_key_id=<>
aws_secret_access_key=<>
``` 

2. Run `terraform init` in the `/terraform` directory

3. Run `terraform apply` and type `yes` when prompted

```
Plan: 13 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: 
```

4. Run `terraform output` to get the dns_name of the load-balancer

5. Go to your browser and search for `<dns-name>:8080` and confirm `Hello, World!` is the output

6. Run `terraform destroy` to prevent unexpected charges on your AWS account.

## Main

For your main file you minimally need a provisioner and security credentials for the account:
```hcl-terraform
# Provider information and cloud deployment region

provider "aws" {
  region = "us-east-2"
  shared_credentials_file = var.creds
}
```
Each time a new provider is added to configuration -- either explicitly via a provider block 
or by adding a resource from that provider `terraform init` must be re-run<br><br>


## Resources
Each resource block describes one or more infrastructure objects, such as virtual networks, compute instances, or higher-level components such as DNS records. <br><br>
Your resources file allows CRUD operations to occur on the resources available from the provisioner.<br><br>
For this AWS-based example this includes launch configurations, ELB configuration, autoscaling and security policies/groups and cloudwatch alarm configuration. 
```hcl-terraform
# launch config for all terraform built servers

resource "aws_launch_configuration" "terraform-example" {
  image_id = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  security_groups = [
    aws_security_group.terraform.id]

  user_data = <<-EOF
                #!/bin/bash
                echo "Hello, World" > index.html
                nohup busybox httpd -f -p ${var.server_port} &
              EOF

  lifecycle {
    create_before_destroy = true
  }

}
```

## Data
data resources are a special type of resource that cause Terraform to **ONLY READ OBJECTS**.<br>  
A data block requests that Terraform read from a given data source ("aws_vpc") and export the result under the given local name ("selected")
<br><br>

The main thing to remember about `data` in terraform is this; If you need information from existing infrastructure in 
AWS searching the `data` modules is where to start.  
```hcl-terraform
# Use all availability zones in region

data "aws_availability_zones" "all" {}

```

## Variables
Variables indirectly represent a value in an expression.
<br><br>They are created in the following form:
```hcl-terraform
variable "example" {}
```

and referenced in other modules with syntax: 

```hcl-terraform
var.example
```
<br>

In this example, I use a variable to represent a file-path to the credentials file for 
connecting to aws:

```hcl-terraform
# Path to credentials file

variable "creds" {
  description = "Credential file location"
  type = string
  default = "~/.aws/credentials"
}
```

