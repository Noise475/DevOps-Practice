# modules/iam/main.tf

# Define IAM role for the OU
resource "aws_iam_role" "ou_role" {
  name               = var.ou_role
  assume_role_policy = file("${path.module}/policies/ou-role.json")
}

# Attach policies to the IAM role
resource "aws_iam_policy_attachment" "env_policy_attachment" {
  name       = "${var.environment}-policy-attachment"
  roles      = [aws_iam_role.ou_role.name]
  policy_arn = ""  # Replace with the ARN of the OU-specific policy
}
