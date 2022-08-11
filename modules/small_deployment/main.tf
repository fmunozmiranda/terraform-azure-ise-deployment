resource "azurerm_public_ip" "public_ip" {
  count = 2
  name                = "${var.ise_base_hostname}acceptanceTestPublicIp${count.index}"
  resource_group_name = var.azure_resource_group_name
  location            = var.azure_resource_group_location
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "ise-pan" {
  count = 2
  name                = "${var.ise_base_hostname}-nic-pan-${count.index}"
  location            = var.azure_resource_group_location
  resource_group_name = var.azure_resource_group_name

  ip_configuration {
    name                          = "testconfiguration${count.index}"
    subnet_id                     = var.internal_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id= azurerm_public_ip.public_ip[count.index].id
  }
}

// Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "ise" {
  count = 2
  network_interface_id      = azurerm_network_interface.ise-pan[count.index].id
  network_security_group_id = var.azure_security_group_id
}

resource "azurerm_storage_account" "mystorageaccount" {
    count = 2
    name                        = "${lower(replace(var.ise_base_hostname, "/[-_]/",""))}saccounttftest${count.index}"
    resource_group_name = var.azure_resource_group_name
    location                    = var.azure_resource_group_location
    account_tier                = "Standard"
    account_replication_type    = "LRS"

    tags = {
        environment = "ISE Storage Account-${count.index}"
    }
}

resource "azurerm_linux_virtual_machine" "example" {
  count = 2
  name                = "${var.ise_base_hostname}-machine-${count.index}"
  resource_group_name = var.azure_resource_group_name
  location            = var.azure_resource_group_location
  size                = "Standard_D16s_v5"
  admin_username      = var.ise_username
  network_interface_ids = [
    azurerm_network_interface.ise-pan[count.index].id
  ]

  user_data              = base64encode("hostname=${ lower(var.ise_base_hostname) }-server\nprimarynameserver=${var.ise_dns_server}\ndnsdomain=${var.ise_domain}\nntpserver=${var.ise_ntp_server}\ntimezone=${var.ise_timezone}\nusername=${ var.ise_username }\npassword=${var.ise_password}")

  computer_name                   = "myvm"
  disable_password_authentication = true
  admin_ssh_key {
    username   = var.ise_username
    public_key = var.ssh_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.mystorageaccount[count.index].primary_blob_endpoint
  }

   # source_image_reference {
  #   publisher = "Canonical"
  #   offer     = "UbuntuServer"
  #   sku       = "16.04-LTS"
  #   version   = "latest"
  # }

  source_image_id = var.source_image_id
}