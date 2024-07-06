# Used to get Account_ID
data "aws_caller_identity" "current" {}

############## SSO Config - import may be required #################
data "aws_ssoadmin_instances" "main" {}

data "aws_identitystore_group" "main" {
  identity_store_id = tolist(data.aws_ssoadmin_instances.main.identity_store_ids)[0]

  alternate_identifier {
    unique_attribute {
      attribute_path  = "DisplayName"
      attribute_value = "DevOps"
    }
  }
}

####################### Github OIDC Config #######################
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
      values = ["repo:${var.github_org}/${var.github_repo}:ref:refs/heads/*",
        "repo:${var.github_org}/${var.github_repo}:environment:*",
        "repo:${var.github_org}/${var.github_repo}:workflow:*"
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "github_permissions" {
  statement {
    actions = [
      "sts:AssumeRoleWithWebIdentity",
      ":sts:AssumeRole"
    ]
    resources = ["*"]
    effect    = "Allow"
  }
}
