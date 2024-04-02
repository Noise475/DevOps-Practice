# modules/iam/main.tf

# Define terraform_role for infrastructure administration
resource "aws_iam_role" "terraform_role" {
  name = "terraform_role"
  assume_role_policy = templatefile("./policies/terraform-role.json", {
    account_id = var.account_id
  })
  tags = {
    env = "${var.environment}"
  }
}

# Define policies for terraform_role
resource "aws_iam_policy" "tf_policy" {
  name        = "root-terraform-policy"
  description = "administrative terraform policy"

  policy = file("./policies/terraform-policy.json")
}

# Attach policies to terraform_role
resource "aws_iam_policy_attachment" "tf_policy_attachment" {
  name       = "${var.environment}-terraform-policy-attachment"
  roles      = [aws_iam_role.terraform_role.name]
  policy_arn = aws_iam_policy.tf_policy.arn
}

# Define IAM role for the OU
resource "aws_iam_role" "ou_role" {
  name = var.environment
  assume_role_policy = templatefile("./policies/ou-role.json", {
    account_id  = var.account_id
    org_id      = var.org_id
    environment = var.environment
  })
  
  tags = {
    env = "${var.environment}"
  }
}

# Define policies for OUs
resource "aws_iam_policy" "ou_tf_state_policy" {
  name        = "${var.environment}-terraform-state-policy"
  description = "Terraform state policy for ${var.environment}"


  policy = templatefile("./policies/terraform-state-policy.json", {
    account_id  = var.account_id
    org_id      = var.org_id
    environment = var.environment
    region      = var.region
  })
}

resource "aws_iam_policy" "eks_policy" {
  name        = "eks-policy"
  description = "IAM policy for Amazon EKS"

  policy = file("./policies/eks-policy.json")
}


# Attach policies to the IAM role
resource "aws_iam_policy_attachment" "env_policy_attachment" {
  name       = "${var.environment}-terraform-state-policy-attachment"
  roles      = [aws_iam_role.ou_role.name]
  policy_arn = aws_iam_policy.ou_tf_state_policy.arn
}


#######################################################
# SSM keys here are placed for loading in the same 
# order as iam module for kms access for service roles
#######################################################

# SSM keys
resource "aws_kms_key" "ssm_key" {
  description             = "KMS key for parameter store"
  deletion_window_in_days = 30
  enable_key_rotation     = true
}

# Key alias
resource "aws_kms_alias" "ssm_key" {
  name = "alias/${var.environment}-parameter-store-key"
  target_key_id = aws_kms_key.ssm_key.key_id
}

# SSM key policy
resource "aws_kms_key_policy" "kms_policy" {
  key_id = aws_kms_key.ssm_key.id

  policy = templatefile("./policies/kms-policy.json", {
    account_id  = var.account_id
    environment = var.environment
  })
}