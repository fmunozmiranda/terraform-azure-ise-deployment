resource "azurerm_public_ip" "public_ip_pan_mnt" {
  count = 2
  name                = "${var.base_name}acceptanceTestPublicIpPanMnt${count.index}"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Dynamic"
}
resource "azurerm_network_interface" "ise-pan-mnt" {
  count = 2
  name                = "${var.base_name}-nic-pan-mnt-${count.index}"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "testconfiguration${count.index}"
    subnet_id                     = var.internal_id
    public_ip_address_id= azurerm_public_ip.public_ip_pan_mnt[count.index].id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface_security_group_association" "ise" {
  count = 2
  network_interface_id      = azurerm_network_interface.ise-pan-mnt[count.index].id
  network_security_group_id = var.security_group_id
}

resource "azurerm_linux_virtual_machine" "ise-pan-mnt" {
  count = 2
  name                = "${var.base_name}-machine-pan-mnt-${count.index}"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = "Standard_B1ls"
  admin_username      = var.username
  network_interface_ids = [
    azurerm_network_interface.ise-pan-mnt[count.index].id
  ]

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

resource "azurerm_public_ip" "public_ip" {
  count = var.ise_psn_instances > 4 ? 4 : var.ise_psn_instances
  name                = "${var.base_name}acceptanceTestPublicIp${count.index}"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "ise" {
  count = var.ise_psn_instances > 4 ? 4 : var.ise_psn_instances
  name                = "${var.base_name}-nic-machine-${count.index}"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "testconfigurationmachine${count.index}"
    subnet_id                     = var.internal_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id= azurerm_public_ip.public_ip[count.index].id
  }
}

resource "azurerm_network_interface_security_group_association" "ise-m" {
  count = var.ise_psn_instances > 4 ? 4 : var.ise_psn_instances
  network_interface_id      = azurerm_network_interface.ise[count.index].id
  network_security_group_id = var.security_group_id
}

resource "azurerm_linux_virtual_machine" "example" {
  depends_on = [
    azurerm_linux_virtual_machine.ise-pan-mnt
  ]
  count = var.ise_psn_instances > 4 ? 4 : var.ise_psn_instances
  name                = "${var.base_name}-machine-${count.index}"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = "Standard_B1ls"
  admin_username      = var.username
  network_interface_ids = [
    azurerm_network_interface.ise[count.index].id
  ]

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