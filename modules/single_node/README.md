# Azure ISE Single Node Deployment Terraform module

Terraform module which creates an ISE Single Node Deployment in Azure.

## Usage

```hcl



<!-- module "ise-deployment" {
  source  = "fmunozmiranda/ise-deployment/aws"
  version = "1.0.8"
  # insert the 17 required variables here
} -->


```

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
None.

## Resources

| Name | Type |
|------|------|
| [azurerm_public_ip](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |
| [azurerm_network_interface](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_group) | resource |
| [azurerm_network_interface_security_group_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_group) | data source |
| [azurerm_linux_virtual_machine](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
|resource_group_name| Resource Group Name | `string` | - | yes|
|location| Resource Group Location | `string` | - | yes |
|ssh_key| SSH Key to connect to Nodes | `string` | - | yes |
|username| ISE Username | `string` | - | yes |
|password| ISE Password | `string` | - | yes |
|base_hostname| ISE Base Hostname | `string` | - | yes |
|internal_id| Internal Id | `string` | - | yes |
|security_group_id| Security Group Id. | `string` | - | yes |

## Outputs

None


## Authors



## License

Apache 2 Licensed. See [LICENSE]() for full details.