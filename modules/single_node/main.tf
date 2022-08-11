resource "azurerm_public_ip" "public_ip" {
  name                = "${var.ise_base_hostname}acceptanceTestPublicIp1"
  resource_group_name = var.azure_resource_group_name
  location            = var.azure_resource_group_location
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "ise" {
  name                = "${var.ise_base_hostname}-nic-machine"
  location            = var.azure_resource_group_location
  resource_group_name = var.azure_resource_group_name
  
  ip_configuration {
    name                          = "testconfigurationmachine"
    subnet_id                     = var.internal_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id= azurerm_public_ip.public_ip.id
  }
}

resource "azurerm_network_interface_security_group_association" "ise" {
  network_interface_id      = azurerm_network_interface.ise.id
  network_security_group_id = var.azure_security_group_id
}
resource "azurerm_storage_account" "mystorageaccount" {
    name                        = "${lower(replace(var.ise_base_hostname, "/[-_]/",""))}saccounttftest"
    resource_group_name = var.azure_resource_group_name
    location                    = var.azure_resource_group_location
    account_tier                = "Standard"
    account_replication_type    = "LRS"

    tags = {
        environment = "ISE Storage Account"
    }
}
resource "azurerm_linux_virtual_machine" "example" {
  name                = "${var.ise_base_hostname}-machine"
  resource_group_name = var.azure_resource_group_name
  location            = var.azure_resource_group_location
  size                = "Standard_D16s_v5"
  admin_username      = var.ise_username
  network_interface_ids = [
    azurerm_network_interface.ise.id
  ]

  user_data              = base64encode("hostname=${ lower(var.ise_base_hostname) }-server\nprimarynameserver=${var.ise_dns_server}\ndnsdomain=${var.ise_domain}\nntpserver=${var.ise_ntp_server}\ntimezone=${var.ise_timezone}\nusername=${ var.ise_username }\npassword=${var.ise_password}")

  admin_ssh_key {
    username   = var.ise_username
    public_key = var.ssh_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  # source_image_reference {
  #   publisher = "Canonical"
  #   offer     = "UbuntuServer"
  #   sku       = "16.04-LTS"
  #   version   = "latest"
  # }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.mystorageaccount.primary_blob_endpoint
  }

  source_image_id = var.source_image_id
}