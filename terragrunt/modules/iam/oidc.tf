data "aws_iam_policy_document" "github_oidc" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"
    principals {
      type        = "Federated"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/token.actions.githubusercontent.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:${var.github_repo}:ref:refs/heads/*"]
    }
  }
}

data "aws_iam_policy_document" "github_permissions" {
  statement {
    actions   = [
      "sts:AssumeRoleWithWebIdentity",
    ]
    resources = ["*"]  # Example: Restrict to specific resources if necessary
    effect    = "Allow"
  }
}

resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["ffffffffffffffffffffffffffffffffffffffff"]

  tags = var.tags
}

resource "aws_iam_role" "github_oidc_role" {
  name               = "github_role"
  assume_role_policy = data.aws_iam_policy_document.github_oidc.json

  tags = var.tags
}

# Attach assume role policy document to IAM role
resource "aws_iam_role_policy_attachment" "github_oidc_policy_attachment" {
  role       = aws_iam_role.github_oidc_role.name
  policy_arn = aws_iam_policy.github_oidc_policy.arn
}

resource "aws_iam_policy" "github_oidc_policy" {
  name   = "github_oidc_policy"
  policy = data.aws_iam_policy_document.github_permissions.json
}
