# modules/iam/main.tf

# Define IAM role for the OU
resource "aws_iam_role" "ou_role" {
  name = var.environment
  assume_role_policy = templatefile("./policies/ou-role.json", {
    account_id  = var.account_id
    org_id      = var.org_id
    environment = var.environment
  })
}

# Attach policies to the IAM role
resource "aws_iam_policy_attachment" "env_policy_attachment" {
  name       = "${var.environment}-terragrunt-policy-attachment"
  roles      = [aws_iam_role.ou_role.name]
  policy_arn = aws_iam_policy.ou_policy.arn
}

# Define policies for each OU
resource "aws_iam_policy" "ou_policy" {
  name        = "${var.environment}-terragrunt-policy"
  description = "Policy for ${var.environment}"

  # Define policy document here
  policy = templatefile("./policies/terraform-state.json", {
    account_id  = var.account_id
    org_id      = var.org_id
    environment = var.environment
    region      = var.region
  })
}

# Attach policies to roles
resource "aws_iam_policy_attachment" "ou_policy_attachments" {
  name       = "${var.environment}-terragrunt-policy-attachment"
  roles      = [aws_iam_role.ou_role.name]
  policy_arn = aws_iam_policy.ou_policy.arn
}

resource "aws_iam_policy" "eks_policy" {
  name        = "eks_policy"
  description = "IAM policy for Amazon EKS"

  policy = file("./policies/eks_policy.json")
}

# SSM keys
resource "aws_kms_key" "ssm_key" {
  description             = "KMS key for parameter store"
  deletion_window_in_days = 30
  enable_key_rotation     = true

  policy = file("./policies/ssm.json")
}
