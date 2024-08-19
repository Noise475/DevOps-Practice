# modules/iam/main.tf
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

#######################################################
# IAM Roles
#######################################################

# Define terraform_role for infrastructure administration
resource "aws_iam_role" "terraform_role" {
  name = "terraform_role"
  assume_role_policy = templatefile("${path.module}/policies/assume-tf-policy.json", {
    account_id = var.account_id
    region     = var.region
  })

  tags = var.tags
}

# Define IAM roles for each environment
resource "aws_iam_role" "ou_role" {
  for_each = toset(var.environments)

  name = each.key
  assume_role_policy = templatefile("${path.module}/policies/assume-env-policy.json", {
    account_id  = var.account_id
    environment = each.key
  })

  tags = var.tags
}

#######################################################
# IAM Policies
#######################################################

# Define policies for terraform_role
resource "aws_iam_policy" "tf_policy" {
  name        = "root-tf-policy"
  description = "administrative terraform policy for root"

  policy = file("${path.module}/policies/root-terraform-policy.json")
  tags   = var.tags
}

# Define policies for each environment
resource "aws_iam_policy" "ou_tf_policy" {
  for_each    = toset(var.environments)
  name        = "${each.key}-terraform-policy"
  description = "administrative terraform policy for ${each.key}"

  policy = templatefile("${path.module}/policies/ou-terraform-policy.json", {
    environment = each.key
    region      = var.region
    account_id  = var.account_id
    table_name  = var.table_name
  })
  tags = var.tags
}

resource "aws_iam_policy" "ou_tf_state_policy" {
  for_each    = toset(var.environments)
  name        = "${each.key}-terraform-state-policy"
  description = "Terraform state policy for ${each.key}"

  policy = templatefile("${path.module}/policies/terraform-state-policy.json", {
    account_id  = var.account_id
    Org_ID      = var.Org_ID
    environment = each.key
    region      = var.region
  })

  tags = var.tags
}

resource "aws_iam_policy" "eks_policy" {
  for_each    = toset(var.environments)
  name        = "${each.key}-eks-policy"
  description = "IAM policy for Amazon EKS"

  policy = templatefile("${path.module}/policies/eks-policy.json", {
    environment = each.key
  })

  tags = var.tags
}

#######################################################
# IAM Policy Attachments
#######################################################

# Attach policies to terraform_role
resource "aws_iam_policy_attachment" "tf_policy_attachment" {
  name       = "root-terraform-policy-attachment"
  roles      = [aws_iam_role.terraform_role.name]
  policy_arn = aws_iam_policy.tf_policy.arn
}

# Attach policies to ou_role for each environment
resource "aws_iam_policy_attachment" "ou_tf_policy_attachment" {
  for_each = toset(var.environments)

  name       = "${each.key}-terraform-policy-attachment"
  roles      = [aws_iam_role.ou_role[each.key].name]
  policy_arn = aws_iam_policy.ou_tf_policy[each.key].arn
}

resource "aws_iam_policy_attachment" "ou_state_policy_attachment" {
  for_each = toset(var.environments)

  name       = "${each.key}-terraform-state-policy-attachment"
  roles      = [aws_iam_role.ou_role[each.key].name, aws_iam_role.terraform_role.name]
  policy_arn = aws_iam_policy.ou_tf_state_policy[each.key].arn
}

resource "aws_iam_policy_attachment" "eks_policy_attachment" {
  for_each = toset(var.environments)

  name       = "${each.key}-eks-policy-attachment"
  roles      = [aws_iam_role.ou_role[each.key].name]
  policy_arn = aws_iam_policy.eks_policy[each.key].arn
}
