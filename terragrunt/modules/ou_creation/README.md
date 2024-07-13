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
| [aws_organizations_organizational_unit.ou](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_organizational_unit) | resource |
| [aws_organizations_organization.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/organizations_organization) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | Current Environment | `string` | n/a | yes |
| <a name="input_ou_names"></a> [ou\_names](#input\_ou\_names) | List of OU names to create | `list(object({ name = string }))` | n/a | yes |
| <a name="input_parent_ou_id"></a> [parent\_ou\_id](#input\_parent\_ou\_id) | ID of the parent OU (optional) | `string` | `"null"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to apply to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_current_ou_id"></a> [current\_ou\_id](#output\_current\_ou\_id) | n/a |
| <a name="output_ou_ids"></a> [ou\_ids](#output\_ou\_ids) | List of ids for organizational units |
| <a name="output_ou_names"></a> [ou\_names](#output\_ou\_names) | n/a |
<!-- END_TF_DOCS -->