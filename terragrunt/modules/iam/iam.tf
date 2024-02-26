# modules/iam/main.tf

# Define IAM role for the OU
resource "aws_iam_role" "ou_role" {
  name = var.environment
  assume_role_policy = templatefile("./policies/ou-role.json.tmpl", {
    account_id  = var.account_id
    org_id      = var.org_id
    environment = var.environment
  })
}

# Attach policies to the IAM role
resource "aws_iam_policy_attachment" "env_policy_attachment" {
  name       = "${var.environment}-policy-attachment"
  roles      = [aws_iam_role.ou_role.name]
  policy_arn = aws_iam_policy.ou_policy.arn
}

# Define policies for each OU
resource "aws_iam_policy" "ou_policy" {
  name        = "ou-${var.environment}-policy"
  description = "Policy for ${var.environment}"

  # Define policy document here
  policy = templatefile("./policies/terraform-state.json.tmpl", {
    account_id  = var.account_id
    org_id      = var.org_id
    environment = var.environment
    region      = var.region
  })
}

# Attach policies to roles
resource "aws_iam_policy_attachment" "ou_policy_attachments" {
  name       = "ou-${var.environment}-policy-attachment"
  roles      = [aws_iam_role.ou_role.name]
  policy_arn = aws_iam_policy.ou_policy.arn
}
