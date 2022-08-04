# Azure ISE Large Deployment Terraform module

Terraform module which creates an ISE Large Deployment in Azure.

## Usage

```hcl





module "ise-deployment_large_deployment" {
  source  = "fmunozmiranda/ise-deployment/azure//modules/large_deployment"
  version = "1.0.0"
  # insert the 14 required variables here
}




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
|azure_resource_group_name| Resource Group Name | `string` | - | yes|
|azure_resource_group_location| Resource Group Location | `string` | - | yes |
|ssh_key| SSH Key to connect to Nodes | `string` | - | yes |
|ise_username| ISE Username | `string` | - | yes |
|ise_password| ISE Password | `string` | - | yes |
|azure_base_hostname| ISE Base Hostname | `string` | - | yes |
|internal_id| Internal Id | `string` | - | yes |
|azure_security_group_id| Security Group Id. | `string` | - | yes |
|ise_psn_instances | ISE PSN Instances | `number` | - | yes |
|source_image_id| ISE Source Image Id. | `string` | `true` | no |
|ise_ntp_server| ISE NTP Server | `string` | - | yes |
|ise_dns_server| ISE DNS Server | `string` | - | yes |
|ise_domain| ISE Domain | `string` | - | yes |
|ise_timezone| ISE Timezone | `string` | - | yes |

## Outputs

None


## Authors



## License

Apache 2 Licensed. See [LICENSE]() for full details.