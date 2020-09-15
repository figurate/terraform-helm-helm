## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| helm | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| chart | Helm chart repository path. May also refer to a local path or a remote package (tgz). | `any` | n/a | yes |
| env | A map of environment settings | `map` | `{}` | no |
| env\_sensitive | A map of sensitive environment settings | `map` | `{}` | no |
| name | Service name | `any` | n/a | yes |
| repository\_url | Optional Helm repository URL | `any` | `null` | no |

## Outputs

No output.

