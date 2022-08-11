azure_resource_group_name           = "TERRAFORM-TEST-3"
azure_resource_group_location       = "South Central US"
azure_virtual_network_name          = "TERRAFORM-VNET"
azure_virtual_network_address_space = ["10.1.0.2/16", "172.100.0.0/16"]
azure_virtual_network_dns_servers   = ["127.0.0.1", "127.0.0.2"]
azure_subnet_name                   = "TERRAFORM-VSUBNET-2"
azure_subnet_address_prefixes       = ["10.1.0.2/24"]
azure_network_security_group_name   = "TERRAFORM-SECURITY-2"
ise_username                        = "adminIse"
ise_password                        = "*********"
ise_deployment                      = "medium_deployment" // This can be (single_node, small_deployment, medium_deployment, large_deployment)
ise_psn_instances                   = 4
ise_base_hostname                   = "ISE-32"
ise_dns_server                      = "208.67.220.220"
ise_domain                          = "sstcloud.com"
ise_ntp_server                      = "10.10.0.1"
ise_timezone                        = "America/Costa_Rica"
source_image_id                     = "/subscriptions/80c00b4f-3c6e-4eb2-bf09-8ad725a2e1ac/resourceGroups/CLOUD-SHELL-STORAGE-SOUTHCENTRALUS/providers/Microsoft.Compute/images/ise-3.2"
create_resource_group               = true
create_virtual_network              = true
create_security_group               = true
create_subnet                       = true
