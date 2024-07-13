<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_openid_connect_provider.github](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_openid_connect_provider) | resource |
| [aws_iam_policy.eks_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.github_oidc_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.ou_tf_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.ou_tf_state_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.tf_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy_attachment.eks_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy_attachment) | resource |
| [aws_iam_policy_attachment.ou_state_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy_attachment) | resource |
| [aws_iam_policy_attachment.ou_tf_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy_attachment) | resource |
| [aws_iam_policy_attachment.tf_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy_attachment) | resource |
| [aws_iam_role.github_oidc_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.ou_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.terraform_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.github_oidc_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_ssoadmin_account_assignment.devops_group_assignment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssoadmin_account_assignment) | resource |
| [aws_ssoadmin_permission_set.assume_tf_role_permission_set](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssoadmin_permission_set) | resource |
| [aws_ssoadmin_permission_set_inline_policy.assume_tf_role_permission_set_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssoadmin_permission_set_inline_policy) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.github_oidc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.github_permissions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_identitystore_group.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/identitystore_group) | data source |
| [aws_ssoadmin_instances.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssoadmin_instances) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_id"></a> [account\_id](#input\_account\_id) | AWS Account ID | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | current aws environment | `string` | n/a | yes |
| <a name="input_environments"></a> [environments](#input\_environments) | List of AWS environments | `list(string)` | n/a | yes |
| <a name="input_github_org"></a> [github\_org](#input\_github\_org) | Github organization name | `string` | `""` | no |
| <a name="input_github_repo"></a> [github\_repo](#input\_github\_repo) | Github repo name | `string` | `"DevOps-Practice"` | no |
| <a name="input_oidc_audience"></a> [oidc\_audience](#input\_oidc\_audience) | OIDC audience | `string` | `""` | no |
| <a name="input_org_id"></a> [org\_id](#input\_org\_id) | AWS Organization ID | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | current AWS region | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to apply to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_account_id"></a> [account\_id](#output\_account\_id) | n/a |
| <a name="output_gh_role_arn"></a> [gh\_role\_arn](#output\_gh\_role\_arn) | n/a |
| <a name="output_ou_role_arn"></a> [ou\_role\_arn](#output\_ou\_role\_arn) | n/a |
| <a name="output_ou_role_arns"></a> [ou\_role\_arns](#output\_ou\_role\_arns) | n/a |
| <a name="output_permission_set_arn"></a> [permission\_set\_arn](#output\_permission\_set\_arn) | n/a |
| <a name="output_sso_group_id"></a> [sso\_group\_id](#output\_sso\_group\_id) | n/a |
| <a name="output_sso_instance_arn"></a> [sso\_instance\_arn](#output\_sso\_instance\_arn) | n/a |
| <a name="output_tf_role_arn"></a> [tf\_role\_arn](#output\_tf\_role\_arn) | n/a |
<!-- END_TF_DOCS -->