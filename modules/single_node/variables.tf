variable "location" {
  type = string
  description = "Resource Group Location"
}

variable "resource_group_name" {
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

variable "security_group_id" {
  type= string
  description = "Security Group Id"
}

variable "username" {
  type= string
  description="ISE Username"
}

variable "password" {
  type= string
  description = "ISE Password"
}

variable "base_name" {
  type = string
  description = "ISE Password"
}