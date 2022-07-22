terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.11.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
  # For test
  features {
    virtual_machine {
      delete_os_disk_on_deletion     = true
      graceful_shutdown              = false
      skip_shutdown_and_force_delete = false
    }
  }
}

/*data "azurerm_shared_image" "example" {
  name                = "my-image"
  gallery_name = 
  resource_group_name = "ise"
}
output "ciscoise_aci_bindings_example" {
  value = data.azurerm_shared_image.example.id
}*/

//Create resource group
resource "azurerm_resource_group" "ise" {
  count = var.create_resource_group ? 1 : 0
  name     = var.resource_group_name
  location = var.resource_group_location
}

//Look for resource group 
data "azurerm_resource_group" "example" {
  count = var.create_resource_group ? 0 : 1
  name = var.resource_group_name
}

//Create virtual network
resource "azurerm_virtual_network" "ise" {
  count = var.create_virtual_network ? 1 : 0
  name                = var.virtual_network_name
  location            = var.create_resource_group ? azurerm_resource_group.ise[0].location : data.azurerm_resource_group.example[0].location
  resource_group_name = var.create_resource_group ? azurerm_resource_group.ise[0].name : var.resource_group_name
  address_space       = var.virtual_network_address_space
  dns_servers         = var.virtual_network_dns_servers

  /*subnet {
    name           = "subnet1"
    address_prefix = "10.0.1.0/24"
  }

  subnet {
    name           = "subnet2"
    address_prefix = "10.0.2.0/24"
    security_group = var.create_security_group ? azurerm_network_security_group.ise[0].id : data.azurerm_network_security_group.example[0].id
  }

  tags = {
    environment = "Production"
  }*/
}

//Look for virtual network
data "azurerm_virtual_network" "example" {
  count = var.create_virtual_network ? 0 : 1
  name                = var.virtual_network_name
  resource_group_name = var.create_resource_group ? azurerm_resource_group.ise[0].name : var.resource_group_name
}


// Create Subnet
resource "azurerm_subnet" "internal" {
  count = var.create_subnet ? 1 : 0 
  name                 = var.subnet_name
  resource_group_name  = var.create_resource_group ? azurerm_resource_group.ise[0].name : var.resource_group_name
  virtual_network_name = var.create_virtual_network ? azurerm_virtual_network.ise[0].name : data.azurerm_virtual_network.example[0].name
  address_prefixes     = var.subnet_address_prefixes
}


// Look for Subnet
data "azurerm_subnet" "example" {
  count = var.create_subnet ? 0 : 1
  name                 = var.subnet_name
  virtual_network_name = var.create_virtual_network ? azurerm_virtual_network.ise[0].name : data.azurerm_virtual_network.example[0].name
  resource_group_name  = var.create_resource_group ? azurerm_resource_group.ise[0].name : var.resource_group_name
}


// Create security group
resource "azurerm_network_security_group" "ise" {
  count = var.create_security_group ? 1 : 0
  name                = var.network_security_group_name
  location            = var.create_resource_group ? azurerm_resource_group.ise[0].location : data.azurerm_resource_group.example[0].location
  resource_group_name = var.create_resource_group ? azurerm_resource_group.ise[0].name : var.resource_group_name
  security_rule {
    name                       = "AllowSSH"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "AllowMultiplePorts"
    priority                   = 102
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "AllowICMP"
    priority                   = 103
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Icmp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}


// Look for security group
data "azurerm_network_security_group" "example" {
  count = var.create_security_group ? 0 : 1
  name                = var.network_security_group_name
  resource_group_name = var.create_resource_group ? azurerm_resource_group.ise[0].name : var.resource_group_name
}


// Create (and display) an SSH key
resource "tls_private_key" "ise_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "local_file" "linuxkey" {
  filename="azure_key.pem"  
  content=tls_private_key.ise_ssh.private_key_pem 
}

# resource "azurerm_ssh_public_key" "example" {
#   name                = "ise_azure_key"
#   resource_group_name = var.resource_group_name
#   location            = var.resource_group_location
#   public_key          = file("~/.ssh/id_rsa.pub")
# }


module "single" {
  count = var.ise_deployment == "single_node" ? 1 : 0
  source = "./modules/single_node"
  location              = var.create_resource_group ? azurerm_resource_group.ise[0].location : data.azurerm_resource_group.example[0].location
  resource_group_name   = var.create_resource_group ? azurerm_resource_group.ise[0].name : var.resource_group_name
  ssh_key= tls_private_key.ise_ssh.public_key_openssh
  internal_id = var.create_subnet ? azurerm_subnet.internal[0].id : data.azurerm_subnet.example[0].id
  security_group_id = var.create_security_group ? azurerm_network_security_group.ise[0].id : data.azurerm_network_security_group.example[0].id
  username= var.ise_username
  password= var.ise_password
  base_name= var.ise_base_hostname
}
module "small" {
  count = var.ise_deployment == "small_deployment" ? 1 : 0
  source = "./modules/small_deployment"
  location              = var.create_resource_group ? azurerm_resource_group.ise[0].location : data.azurerm_resource_group.example[0].location
  resource_group_name   = var.create_resource_group ? azurerm_resource_group.ise[0].name : var.resource_group_name
  ssh_key= tls_private_key.ise_ssh.public_key_openssh
  internal_id = var.create_subnet ? azurerm_subnet.internal[0].id : data.azurerm_subnet.example[0].id
  security_group_id = var.create_security_group ? azurerm_network_security_group.ise[0].id : data.azurerm_network_security_group.example[0].id
  username= var.ise_username
  password= var.ise_password
  base_name= var.ise_base_hostname
}
module "medium" {
  count = var.ise_deployment == "medium_deployment" ? 1 : 0
  source = "./modules/medium_deployment"
  location              = var.create_resource_group ? azurerm_resource_group.ise[0].location : data.azurerm_resource_group.example[0].location
  resource_group_name   = var.create_resource_group ? azurerm_resource_group.ise[0].name : var.resource_group_name
  ssh_key= tls_private_key.ise_ssh.public_key_openssh
  ise_psn_instances = var.ise_psn_instances
  internal_id = var.create_subnet ? azurerm_subnet.internal[0].id : data.azurerm_subnet.example[0].id
  security_group_id = var.create_security_group ? azurerm_network_security_group.ise[0].id : data.azurerm_network_security_group.example[0].id
  username= var.ise_username
  password= var.ise_password
  base_name= var.ise_base_hostname
}
module "large" {
  count = var.ise_deployment == "large_deployment" ? 1 : 0
  source = "./modules/large_deployment"
  location              = var.create_resource_group ? azurerm_resource_group.ise[0].location : data.azurerm_resource_group.example[0].location
  resource_group_name   = var.create_resource_group ? azurerm_resource_group.ise[0].name : var.resource_group_name
  ssh_key= tls_private_key.ise_ssh.public_key_openssh
  ise_psn_instances = var.ise_psn_instances
  internal_id = var.create_subnet ? azurerm_subnet.internal[0].id : data.azurerm_subnet.example[0].id
  security_group_id = var.create_security_group ? azurerm_network_security_group.ise[0].id : data.azurerm_network_security_group.example[0].id
  username= var.ise_username
  password= var.ise_password
  base_name= var.ise_base_hostname
}
