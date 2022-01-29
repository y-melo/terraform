##################################################################################
# RESOURCES
##################################################################################

resource "azurerm_resource_group" "group" {
  name     = local.group_name
  location = local.location
  tags     = local.common_tags
}

resource "azurerm_virtual_network" "vnet" {
  name                = local.vnet_name
  location            = local.location
  resource_group_name = azurerm_resource_group.group.name
  address_space       = [local.network_address_prefix]

  tags = local.common_tags
}

resource "azurerm_subnet" "subnet" {
  name                 = local.subnet_name
  resource_group_name  = azurerm_resource_group.group.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [lookup(local.subnet_address_prefix, local.env)]
  service_endpoints    = ["Microsoft.Storage", "Microsoft.KeyVault", "Microsoft.Sql"]
}

resource "azurerm_subnet_network_security_group_association" "subnet-nsg-assoc" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.nsg_default.id
}

resource "azurerm_public_ip" "pip" {
  name                = "pip-${local.vm_full_name}"
  resource_group_name = azurerm_resource_group.group.name
  location            = azurerm_resource_group.group.location
  allocation_method   = "Static"

  tags = local.common_tags
}

resource "azurerm_network_interface" "vm_nic" {
  name                = "nic-${local.vm_full_name}"
  location            = azurerm_resource_group.group.location
  resource_group_name = azurerm_resource_group.group.name
  
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.pip.id
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                            = local.vm_full_name
  resource_group_name             = azurerm_resource_group.group.name
  location                        = azurerm_resource_group.group.location
  size                            = var.vm_size
  admin_username                  = var.username
  network_interface_ids = [
    azurerm_network_interface.vm_nic.id,
  ]

  admin_ssh_key {
    username   = var.username
    public_key = file(var.ssh_file_path)
  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = var.publisher
    offer     = var.offer
    sku       = var.sku
    version   = "latest"
  }
}
