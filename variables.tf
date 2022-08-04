variable "azure_resource_group_name" {
  type        = string
  description = "Azure Resource Group Name"
}

variable "azure_resource_group_location" {
  type        = string
  description = "Azure Resource Location"
}

variable "azure_virtual_network_name" {
  type        = string
  description = "Azure Virtual Network Name For ISE."
}

variable "azure_virtual_network_address_space" {
  type        = list(string) //["10.1.0.0/16","172.100.0.0/16"]
  description = "Azure Virtual Network Adress Space For ISE."
}

variable "azure_virtual_network_dns_servers" {
  type        = list(string)
  description = "Azure Virtual Network DNS Servers For ISE."
}

variable "azure_subnet_name" {
  type        = string
  description = "Azure Subnet Network Name For ISE."
}

variable "azure_subnet_address_prefixes" {
  type        = list(string) //["10.1.2.0/24"]
  description = "Azure Subnet Address Prefixes For ISE."
}

variable "azure_network_security_group_name" {
  type        = string
  description = "Azure Network Security Group Name For ISE."
}

variable "ise_username" {
  type        = string
  description = "ISE Username."
}

variable "ise_password" {
  type        = string
  description = "ISE Password."
}

variable "ise_deployment" {
  type = string
  validation {
    condition     = var.ise_deployment == "single_node" || var.ise_deployment == "small_deployment" || var.ise_deployment == "medium_deployment" || var.ise_deployment == "large_deployment"
    error_message = "The ise_deployment value must be a some of values : (single_node, small_deployment, medium_deployment, large_deployment)."
  }
  description = "ISE Type Deployment, it should be one of: (single_node, small_deployment, medium_deployment, large_deployment)."
}

variable "ise_psn_instances" {
  type        = number
  description = "ISE PSN Instances."
  default     = 0
}

variable "ise_base_hostname" {
  type        = string
  description = "ISE Base Hostname."
}

variable "create_resource_group" {
  type        = bool
  default     = true
  description = "Determines to create or not a new Resource Group."
}

variable "create_virtual_network" {
  type        = bool
  default     = true
  description = "Determines to create or not a new Virtual Network."
}

variable "create_security_group" {
  type        = bool
  default     = true
  description = "Determines to create or not a new Security Group."
}

variable "create_subnet" {
  type        = bool
  default     = true
  description = "Determines to create or not a new Subnet."
}

variable "ise_ntp_server" {
  description = "ISE Server NTP"
  type        = string
}

variable "ise_dns_server" {
  description = "ISE Server DNS"
  type        = string
}

variable "ise_domain" {
  description = "ISE Server Domain"
  type        = string
}

variable "ise_timezone" {
  description = "ISE Server Timezone"
  type        = string
}

variable "source_image_id" {
  description = "ISE Source Image Id"
  type        = string
}