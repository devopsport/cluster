# Terraform Module - VPC

[![Build](https://github.com/devopsport/cluster/actions/workflows/main.yml/badge.svg?branch=main)](https://github.com/devopsport/cluster/actions/workflows/main.yml)
[![GitHub Issues](https://img.shields.io/github/issues/devopsport/cluster.svg)](https://github.com/devopsport/cluster/issues)
[![GitHub Tag](https://img.shields.io/github/tag-date/devopsport/cluster.svg?style=plastic)](https://github.com/devopsport/cluster/tags/)
![GitHub release (latest by date)](https://img.shields.io/github/v/release/devopsport/cluster)

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

## Authors

The module is maintained by [DevOpsPort](https://github.com/devopsport)