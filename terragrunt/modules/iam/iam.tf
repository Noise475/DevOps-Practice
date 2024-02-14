# modules/iam/main.tf

# Define IAM role for the OU
resource "aws_iam_role" "ou_role" {
  name               = var.ou_role
  assume_role_policy = file("./policies/ou-role.json")
}

# Attach policies to the IAM role
resource "aws_iam_policy_attachment" "env_policy_attachment" {
  name       = "${var.environment}-policy-attachment"
  roles      = [aws_iam_role.ou_role.name]
  policy_arn = "" # Replace with the ARN of the OU-specific policy
}

# Define policies for each OU
resource "aws_iam_policy" "ou_policy" {
  name        = "OU-${var.environment}-Policy"
  description = "Policy for ${var.environment}"

  # Define policy document here
  policy = file("./policies/env-perms.json")
}

# Attach policies to roles
resource "aws_iam_policy_attachment" "ou_policy_attachments" {
  name       = "OU-${var.environment}-Policy-Attachment"
  roles      = [aws_iam_role.ou_role.name]
  policy_arn = aws_iam_policy.ou_policy.arn
}
