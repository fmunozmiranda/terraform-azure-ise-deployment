resource "azurerm_public_ip" "public_ip_pan" {
  count = 2
  name                = "${var.base_name}acceptanceTestPublicIpPan${count.index}"
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
  network_security_group_id = var.security_group_id
}

resource "azurerm_linux_virtual_machine" "ise-pan" {
  depends_on = [
    azurerm_network_interface_security_group_association.ise-pan
  ]
  count = 2
  name                = "${var.base_name}-pan-${count.index}"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = "Standard_B1ls"
  admin_username      = var.username
  network_interface_ids = [
    azurerm_network_interface.ise-pan[count.index].id
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

resource "azurerm_public_ip" "public_ip_mnt" {
  count = 2
  name                = "${var.base_name}acceptanceTestPublicIpMnt${count.index}"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "ise-mnt" {
  count = 2
  name                = "${var.base_name}-nic-mnt-${count.index}"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "testconfigurationmnt${count.index}"
    subnet_id                     = var.internal_id
    public_ip_address_id= azurerm_public_ip.public_ip_mnt[count.index].id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface_security_group_association" "ise-mnt" {
  count = 2
  network_interface_id      = azurerm_network_interface.ise-mnt[count.index].id
  network_security_group_id = var.security_group_id
}

resource "azurerm_linux_virtual_machine" "ise-mnt" {
  depends_on = [
    azurerm_linux_virtual_machine.ise-pan
  ]
  count = 2
  name                = "${var.base_name}-mnt-${count.index}"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = "Standard_B1ls"
  admin_username      = var.username
  network_interface_ids = [
    azurerm_network_interface.ise-mnt[count.index].id
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
  count = var.ise_psn_instances
  name                = "${var.base_name}acceptanceTestPublicIp${count.index}"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Dynamic"
}


resource "azurerm_network_interface" "ise" {
  depends_on = [
    azurerm_linux_virtual_machine.ise-mnt
  ]
  count = var.ise_psn_instances
  name                = "${var.base_name}-nic-machine-${count.index}"
  location            = var.location
  resource_group_name = var.resource_group_name

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
  network_security_group_id = var.security_group_id
}

resource "azurerm_linux_virtual_machine" "example" {
  depends_on = [
    azurerm_network_interface_security_group_association.ise-machine
  ]
  count = var.ise_psn_instances
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