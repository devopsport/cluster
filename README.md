# Terraform Module - VPC

[![Build](https://github.com/devopsport/vpc/actions/workflows/main.yml/badge.svg?branch=main)](https://github.com/devopsport/vpc/actions/workflows/main.yml)
[![GitHub Issues](https://img.shields.io/github/issues/devopsport/vpc.svg)](https://github.com/devopsport/vpc/issues)
[![GitHub Tag](https://img.shields.io/github/tag-date/devopsport/vpc.svg?style=plastic)](https://github.com/devopsport/vpc/tags/)
![GitHub release (latest by date)](https://img.shields.io/github/v/release/devopsport/vpc)

## Usage

```hcl
module "main" {
  source  = "github.com/devopsport/cluster"

  project           = "titan"
  env               = "staging"
  domain            = "api.falcon.staging.punkerside.io"
  containerInsights = true
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0.0 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 3.5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_eip.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_internet_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_nat_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_route_table.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a project="input_project"></a> [name](#input\_project) | Nombre del proyecto | `string` | `titan` | no |
| <a env="input_env"></a> [name](#input\_env) | Nombre del ambiente | `string` | `staging` | no |
| <a domain="input_domain"></a> [name](#input\_domain) | Nombre del dominio | `string` | `api.falcon.staging.punkerside.io` | no |
| <a containerInsights="input_containerInsights"></a> [name](#input\_containerInsights) | Nombre del proyecto | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a id="output_id"></a> [id](#output\_id) | Ide de Cluster ECS |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Docs

```sh
make precommit
```

## Authors

The module is maintained by [DevOpsPort](https://github.com/devopsport)