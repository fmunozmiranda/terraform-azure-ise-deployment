resource "azurerm_public_ip" "public_ip" {
  count = 2
  name                = "${var.base_name}acceptanceTestPublicIp${count.index}"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "ise-pan" {
  count = 2
  name                = "${var.base_name}-nic-pan-${count.index}"
  location            = var.location
  resource_group_name = var.resource_group_name

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
  network_security_group_id = var.security_group_id
}

resource "azurerm_linux_virtual_machine" "example" {
  count = 2
  name                = "${var.base_name}-machine-${count.index}"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = "Standard_B1ls"
  admin_username      = var.username
  network_interface_ids = [
    azurerm_network_interface.ise-pan[count.index].id
  ]


  computer_name                   = "myvm"
  disable_password_authentication = true
  admin_ssh_key {
    username   = var.username
    public_key = var.ssh_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  # source_image_id = "/subscriptions/80c00b4f-3c6e-4eb2-bf09-8ad725a2e1ac/resourceGroups/ise/providers/Microsoft.Compute/images/ise-3.2.0.364"
}