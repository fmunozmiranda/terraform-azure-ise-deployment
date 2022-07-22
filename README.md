# Azure ISE Deployment Terraform module

Terraform module which creates an ISE Deployment in AWS.

## Usage

```hcl



<!-- module "ise-deployment" {
  source  = "fmunozmiranda/ise-deployment/aws"
  version = "1.0.8"
  # insert the 17 required variables here
} -->



```

## Examples

<!-- - [SQS queues with server-side encryption (SSE) using KMS and without SSE](https://github.com/terraform-aws-modules/terraform-aws-sqs/tree/master/examples/complete) -->

<!-- - [ISE Deployment with Network ISE creation](https://github.com/fmunozmiranda/terraform-aws-ise-deployment/tree/main/examples/ise-deployment-with-network-ise-creation)
- [ISE Deployment without Network ISE creation](https://github.com/fmunozmiranda/terraform-aws-ise-deployment/tree/main/examples/ise-deployment-with-no-network-creation) -->

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.1 |
| <a name="requirement_azure"></a> [azure](#requirement\_azure) | >= 3.11.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="requirement_azure"></a> [azure](#requirement\_azure) | >= 3.11.0 |

## Modules

| Name | Type |
|------|------|
| [large_deployment](https://registry.terraform.io/modules/fmunozmiranda/ise-deployment/aws/1.0.7/submodules/large_deployment) | internal |
| [medium_deployment](https://registry.terraform.io/modules/fmunozmiranda/ise-deployment/aws/1.0.7/submodules/medium_deployment) | internal |
| [small_deployment](https://registry.terraform.io/modules/fmunozmiranda/ise-deployment/aws/1.0.7/submodules/small_deployment) | internal |
| [single_node](https://registry.terraform.io/modules/fmunozmiranda/ise-deployment/aws/1.0.7/submodules/single_node_deployment) | internal |

## Resources

| Name | Type |
|------|------|
| [azurerm_resource_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |
| [azurerm_resource_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_group) | resource |
| [azurerm_virtual_network](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_group) | data source |
| [azurerm_virtual_network](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_group) | resource |
| [azurerm_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_group) | data source |
| [azurerm_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_group) | resource |
| [azurerm_network_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_group) | data source |
| [azurerm_network_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_group) | resource |
| [tls_private_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_group) | resource |
| [local_file](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
|resource_group_name| Resource Group Name | `string` | - | yes|
|resource_group_location| Resource Group Location | `string` | - | yes |
|virtual_network_name| Virtual Network Name For ISE | `string` | - | yes |
|virtual_network_address_space| Virtual Network Address Space For ISE| `string` | - | yes |
|virtual_network_dns_servers| Virtual Network DNS Servers | `string` | - | yes |
|subnet_name| Virtual Subnet Name For ISE | `string` | - | yes |
|subnet_address_prefixes| Subnet Address Prefixes For ISE | `string` | - | yes |
|network_security_group_name| Network Security Group Name For ISE | `string` | - | yes |
|ise_username| ISE Username | `string` | - | yes |
|ise_password| ISE Password | `string` | - | yes |
|ise_deployment| ISE Deployment | `string` | - | yes |
|ise_psn_instances| ISE PSN Instances | `number` | `0` | no |
|ise_base_hostname| ISE Base Hostname | `string` | - | yes |
|create_resource_group| Determines to create or not a new Resource Group. | `boolean` | `true` | no |
|create_virtual_network| Determines to create or not a new Virtual Network. | `string` | `true` | no |
|create_security_group| Determines to create or not a new Security Group. | `string` | `true` | no |
|create_subnet| Determines to create or not a new Subnet. | `string` | `true` | no |

## Outputs

None


## Authors



## License

Apache 2 Licensed. See [LICENSE]() for full details.
