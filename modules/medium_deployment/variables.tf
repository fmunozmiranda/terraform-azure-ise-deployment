variable "azure_resource_group_location" {
  type = string
  description = "Resource Group Location"
}

variable "azure_resource_group_name" {
  type = string
  description = "Resource Group Name"
}

variable "ssh_key" {
  type = string
  description = "SSH Key"
}

variable "internal_id" {
  type = string
  description = "Internal Id"
}

variable "azure_security_group_id" {
  type= string
  description = "Security Group Id"
}

variable "ise_username" {
  type= string
  description="ISE Username"
}
variable "ise_password" {
  type= string
  description = "ISE Password"
}

variable "ise_base_hostname" {
  type = string
  description = "ISE Password"
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
variable "ise_psn_instances" {
  type = number
  description = "ISE PSN Instances"
}