#####################################################################
# RESOURCES
#####################################################################

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


## LINUX RESOURCES ##

resource "azurerm_public_ip" "pipl" {
  name                = "pipl-${local.vml_full_name}"
  resource_group_name = azurerm_resource_group.group.name
  location            = azurerm_resource_group.group.location
  allocation_method   = "Static"

  tags = local.common_tags
}

resource "azurerm_network_interface" "vml_nic" {
  name                = "nic-${local.vml_full_name}"
  location            = azurerm_resource_group.group.location
  resource_group_name = azurerm_resource_group.group.name
  
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.pipl.id
  }
}

resource "azurerm_linux_virtual_machine" "vml" {
  name                            = local.vml_full_name
  resource_group_name             = azurerm_resource_group.group.name
  location                        = azurerm_resource_group.group.location
  size                            = var.linux_vm_size
  admin_username                  = var.username
  network_interface_ids = [
    azurerm_network_interface.vml_nic.id,
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
    publisher = var.linux_publisher
    offer     = var.linux_offer
    sku       = var.linux_sku
    version   = "latest"
  }
}


## WINDOWS RESOURCES ##

resource "azurerm_public_ip" "pipw" {
  name                = "pipw-${local.vml_full_name}"
  resource_group_name = azurerm_resource_group.group.name
  location            = azurerm_resource_group.group.location
  allocation_method   = "Static"

  tags = local.common_tags
}

resource "azurerm_network_interface" "vmw_nic" {
  name                = "nic-${local.vmw_full_name}"
  location            = azurerm_resource_group.group.location
  resource_group_name = azurerm_resource_group.group.name
  
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.pipw.id
  }
}

resource "azurerm_windows_virtual_machine" "vmw" {
  name                            = local.vmw_full_name
  resource_group_name             = azurerm_resource_group.group.name
  location                        = azurerm_resource_group.group.location
  size                            = var.win_vm_size
  admin_username                  = var.username
  admin_password                  = var.win_password

  network_interface_ids = [
    azurerm_network_interface.vmw_nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = var.win_publisher
    offer     = var.win_offer
    sku       = var.win_sku
    version   = "latest"
  }

}