resource "azurerm_public_ip" "public_ip_pan" {
  count = 2
  name                = "${var.ise_base_hostname}acceptanceTestPublicIpPan${count.index}"
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
    public_ip_address_id= azurerm_public_ip.public_ip_pan[count.index].id
    private_ip_address_allocation = "Dynamic"
  }
}

// Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "ise-pan" {
  depends_on = [
    azurerm_network_interface.ise-pan
  ]
  count = 2
  network_interface_id      = azurerm_network_interface.ise-pan[count.index].id
  network_security_group_id = var.azure_security_group_id
}

resource "azurerm_storage_account" "mystorageaccountpan" {
    count = 2
    name                        = "${lower(replace(var.ise_base_hostname, "/[-_]/",""))}saccountpan${count.index}"
    resource_group_name = var.azure_resource_group_name
    location                    = var.azure_resource_group_location
    account_tier                = "Standard"
    account_replication_type    = "LRS"

    tags = {
        environment = "ISE Storage Account-PAN-${count.index}"
    }
}

resource "azurerm_linux_virtual_machine" "ise-pan" {
  depends_on = [
    azurerm_network_interface_security_group_association.ise-pan
  ]
  count = 2
  name                = "${var.ise_base_hostname}-pan-${count.index}"
  resource_group_name = var.azure_resource_group_name
  location            = var.azure_resource_group_location
  size                = "Standard_D16s_v5"
  admin_username      = var.ise_username
  network_interface_ids = [
    azurerm_network_interface.ise-pan[count.index].id
  ]

  user_data              = base64encode("hostname=${ lower(var.ise_base_hostname) }-server-pan\nprimarynameserver=${var.ise_dns_server}\ndnsdomain=${var.ise_domain}\nntpserver=${var.ise_ntp_server}\ntimezone=${var.ise_timezone}\nusername=${ var.ise_username }\npassword=${var.ise_password}")

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
    storage_account_uri = azurerm_storage_account.mystorageaccountpan[count.index].primary_blob_endpoint
  }
  source_image_id = var.source_image_id
}

resource "azurerm_public_ip" "public_ip_mnt" {
  count = 2
  name                = "${var.ise_base_hostname}acceptanceTestPublicIpMnt${count.index}"
  resource_group_name = var.azure_resource_group_name
  location            = var.azure_resource_group_location
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "ise-mnt" {
  count = 2
  name                = "${var.ise_base_hostname}-nic-mnt-${count.index}"
  location            = var.azure_resource_group_location
  resource_group_name = var.azure_resource_group_name

  ip_configuration {
    name                          = "testconfigurationmnt${count.index}"
    subnet_id                     = var.internal_id
    public_ip_address_id= azurerm_public_ip.public_ip_mnt[count.index].id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_storage_account" "mystorageaccountmnt" {
    count = 2
    name                        = "${lower(replace(var.ise_base_hostname, "/[-_]/",""))}saccountmnt${count.index}"
    resource_group_name = var.azure_resource_group_name
    location                    = var.azure_resource_group_location
    account_tier                = "Standard"
    account_replication_type    = "LRS"

    tags = {
        environment = "ISE Storage Account-mnt-${count.index}"
    }
}

resource "azurerm_network_interface_security_group_association" "ise-mnt" {
  count = 2
  network_interface_id      = azurerm_network_interface.ise-mnt[count.index].id
  network_security_group_id = var.azure_security_group_id
}

resource "azurerm_linux_virtual_machine" "ise-mnt" {
  depends_on = [
    azurerm_linux_virtual_machine.ise-pan
  ]
  count = 2
  name                = "${var.ise_base_hostname}-mnt-${count.index}"
  resource_group_name = var.azure_resource_group_name
  location            = var.azure_resource_group_location
  size                = "Standard_D16s_v5"
  admin_username      = var.ise_username
  network_interface_ids = [
    azurerm_network_interface.ise-mnt[count.index].id
  ]

  user_data              = base64encode("hostname=${ lower(var.ise_base_hostname) }-server-mnt\nprimarynameserver=${var.ise_dns_server}\ndnsdomain=${var.ise_domain}\nntpserver=${var.ise_ntp_server}\ntimezone=${var.ise_timezone}\nusername=${ var.ise_username }\npassword=${var.ise_password}")

  admin_ssh_key {
    username   = var.ise_username
    public_key = var.ssh_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.mystorageaccountmnt[count.index].primary_blob_endpoint
  }

   # source_image_reference {
  #   publisher = "Canonical"
  #   offer     = "UbuntuServer"
  #   sku       = "16.04-LTS"
  #   version   = "latest"
  # }

  source_image_id = var.source_image_id
}

resource "azurerm_public_ip" "public_ip" {
  count = var.ise_psn_instances
  name                = "${var.ise_base_hostname}acceptanceTestPublicIp${count.index}"
  resource_group_name = var.azure_resource_group_name
  location            = var.azure_resource_group_location
  allocation_method   = "Dynamic"
}


resource "azurerm_network_interface" "ise" {
  depends_on = [
    azurerm_linux_virtual_machine.ise-mnt
  ]
  count = var.ise_psn_instances
  name                = "${var.ise_base_hostname}-nic-machine-${count.index}"
  location            = var.azure_resource_group_location
  resource_group_name = var.azure_resource_group_name

  ip_configuration {
    name                          = "testconfigurationmnt${count.index}"
    subnet_id                     = var.internal_id
    public_ip_address_id= azurerm_public_ip.public_ip[count.index].id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface_security_group_association" "ise-machine" {
  depends_on = [
    azurerm_network_interface.ise
  ]
  count = var.ise_psn_instances
  network_interface_id      = azurerm_network_interface.ise[count.index].id
  network_security_group_id = var.azure_security_group_id
}

resource "azurerm_storage_account" "mystorageaccount" {
    count = var.ise_psn_instances
    name                        = "${lower(replace(var.ise_base_hostname, "/[-_]/",""))}saccount${count.index}"
    resource_group_name = var.azure_resource_group_name
    location                    = var.azure_resource_group_location
    account_tier                = "Standard"
    account_replication_type    = "LRS"

    tags = {
        environment = "ISE Storage Account-${count.index}"
    }
}


resource "azurerm_linux_virtual_machine" "example" {
  depends_on = [
    azurerm_network_interface_security_group_association.ise-machine
  ]
  count = var.ise_psn_instances
  name                = "${var.ise_base_hostname}-machine-${count.index}"
  resource_group_name = var.azure_resource_group_name
  location            = var.azure_resource_group_location
  size                = "Standard_D16s_v5"
  admin_username      = var.ise_username
  network_interface_ids = [
    azurerm_network_interface.ise[count.index].id
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
    storage_account_uri = azurerm_storage_account.mystorageaccount[count.index].primary_blob_endpoint
  }

  source_image_id = var.source_image_id
}