# Azure ISE Deployment Terraform module

Terraform module which creates an ISE Deployment in Azure.

## Usage

```hcl



module "ise-deployment" {
  source  = "fmunozmiranda/ise-deployment/azure"
  version = "1.0.1"
  azure_resource_group_name           = "TERRAFORM-TEST-3"
  azure_resource_group_location       = "South Central US"
  azure_virtual_network_name          = "TERRAFORM-VNET"
  azure_virtual_network_address_space = ["10.1.0.1/16", "172.100.0.0/16"]
  azure_virtual_network_dns_servers   = ["127.0.0.1", "127.0.0.2"]
  azure_subnet_name                   = "Subnet Name"
  azure_subnet_address_prefixes       = ["10.1.0.1/24"]
  azure_network_security_group_name   = "Security Group Name"
  ise_username                        = "Ise Username"
  ise_password                        = "*********"
  ise_deployment                      = "large_deployment" // This can be (single_node, small_deployment, medium_deployment, large_deployment)
  ise_psn_instances                   = 4
  ise_base_hostname                   = "Base_Name_for_nodes"
  ise_dns_server                      = "208.67.220.220"
  ise_domain                          = "sstcloud.com"
  ise_ntp_server                      = "10.10.0.1"
  ise_timezone                        = "America/Costa_Rica"
  source_image_id                     = "ImageID"
  create_resource_group               = true
  create_virtual_network              = true
  create_security_group               = true
  create_subnet                       = true
}



```

## Examples

<!-- - [SQS queues with server-side encryption (SSE) using KMS and without SSE](https://github.com/terraform-aws-modules/terraform-aws-sqs/tree/master/examples/complete) -->

<!-- - [ISE Deployment with Network ISE creation](https://github.com/fmunozmiranda/terraform-aws-ise-deployment/tree/main/examples/ise-deployment-with-network-ise-creation)
- [ISE Deployment without Network ISE creation](https://github.com/fmunozmiranda/terraform-aws-ise-deployment/tree/main/examples/ise-deployment-with-no-network-creation) -->

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13.1 |
| azure | >= 3.11.0 |

## Providers

| Name | Version |
|------|---------|
| azure | >= 3.11.0 |

## Modules

| Name | Type |
|------|------|
| [large_deployment](https://github.com/fmunozmiranda/terraform-azure-ise-deployment/tree/main/modules/large_deployment) | internal |
| [medium_deployment](https://github.com/fmunozmiranda/terraform-azure-ise-deployment/tree/main/modules/medium_deployment) | internal |
| [small_deployment](https://github.com/fmunozmiranda/terraform-azure-ise-deployment/tree/main/modules/small_deployment) | internal |
| [single_node](https://github.com/fmunozmiranda/terraform-azure-ise-deployment/tree/main/modules/single_node) | internal |

## Resources

| Name | Type |
|------|------|
| [azurerm_resource_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_resource_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_virtual_network](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | data source |
| [azurerm_virtual_network](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |
| [azurerm_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |
| [azurerm_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_network_security_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/network_security_group) | data source |
| [azurerm_network_security_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [tls_private_key](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [local_file](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
|azure_resource_group_name| Resource Group Name | `string` | - | yes|
|azure_resource_group_location| Resource Group Location | `string` | - | yes |
|azure_virtual_network_name| Virtual Network Name For ISE | `string` | - | yes |
|azure_virtual_network_address_space| Virtual Network Address Space For ISE| `string` | - | yes |
|azure_virtual_network_dns_servers| Virtual Network DNS Servers | `string` | - | yes |
|azure_subnet_name| Virtual Subnet Name For ISE | `string` | - | yes |
|azure_subnet_address_prefixes| Subnet Address Prefixes For ISE | `string` | - | yes |
|azure_network_security_group_name| Network Security Group Name For ISE | `string` | - | yes |
|ise_username| ISE Username | `string` | - | yes |
|ise_password| ISE Password | `string` | - | yes |
|ise_ntp_server| ISE NTP Server | `string` | - | yes |
|ise_dns_server| ISE DNS Server | `string` | - | yes |
|ise_domain| ISE Domain | `string` | - | yes |
|ise_timezone| ISE Timezone | `string` | - | yes |
|ise_deployment| ISE Deployment | `string` | - | yes |
|ise_psn_instances| ISE PSN Instances | `number` | `0` | no |
|ise_base_hostname| ISE Base Hostname | `string` | - | yes |
|create_resource_group| Determines to create or not a new Resource Group. | `boolean` | `true` | no |
|create_virtual_network| Determines to create or not a new Virtual Network. | `string` | `true` | no |
|create_security_group| Determines to create or not a new Security Group. | `string` | `true` | no |
|create_subnet| Determines to create or not a new Subnet. | `string` | `true` | no |
|source_image_id| ISE Source Image Id. | `string` | `true` | no |

## Assumptions
- If you don't put `ise_psn_instances` inside the parameters when running a medium or large deployment, the psn nodes are skipped.
- If you're not going to create subnet, you can include `azure_subnet_address_prefixes` parameter as empty string.
- The created SSH key is stored in the folder where the `main.tf` is executed.
- This module does not consider possible errors due to security rules in ISE that may prevent the execution of the deployment.
- If `create_resource_group` is not included, the default is create it.
- If `create_virtual_network` is not included, the default is create it.
- If `create_security_group` is not included, the default is create it.
- If `create_subnet` is not included, the default is create it.

## Outputs

None


## Authors



## License

Apache 2 Licensed. See [LICENSE]() for full details.
