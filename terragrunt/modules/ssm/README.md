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
| [aws_ssm_parameter.ou_role_arn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | current environment | `string` | n/a | yes |
| <a name="input_ou_role_arn"></a> [ou\_role\_arn](#input\_ou\_role\_arn) | current organization role ARN | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->