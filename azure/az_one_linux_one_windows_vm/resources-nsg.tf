
resource "azurerm_network_security_group" "nsg_default" {
  name                = "nsg-default"
  resource_group_name = azurerm_resource_group.group.name
  location            = local.location

}

resource "azurerm_network_security_rule" "allow-in-http" {
  name                        = "a-in-http"
  priority                    = 1000
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "TCP"
  source_port_range           = "*"
  source_address_prefixes     = var.allowed_ssh_ips
  destination_port_ranges      = ["80","443","8983"]
  destination_address_prefix  = "*"
  resource_group_name = azurerm_resource_group.group.name
  network_security_group_name = azurerm_network_security_group.nsg_default.name
}

resource "azurerm_network_security_rule" "allow-in-ssh" {
  name                        = "a-in-ssh"
  priority                    = 1100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "TCP"
  source_port_range           = "*"
  source_address_prefixes     = var.allowed_ssh_ips
  destination_port_range      = "22"
  destination_address_prefix  = "*"
  resource_group_name = azurerm_resource_group.group.name
  network_security_group_name = azurerm_network_security_group.nsg_default.name
}

resource "azurerm_network_security_rule" "allow-in-rdp" {
  name                        = "a-in-rdp"
  priority                    = 1110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "TCP"
  source_port_range           = "*"
  source_address_prefixes     = var.allowed_ssh_ips
  destination_port_range      = "3389"
  destination_address_prefix  = "*"
  resource_group_name = azurerm_resource_group.group.name
  network_security_group_name = azurerm_network_security_group.nsg_default.name
}

resource "azurerm_network_security_rule" "a-in-vnet-all" {
  name                        = "a-in-vnet-all"
  priority                    = 3900
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "VIRTUALNETWORK"
  destination_address_prefix  = "VIRTUALNETWORK"
  resource_group_name = azurerm_resource_group.group.name
  network_security_group_name = azurerm_network_security_group.nsg_default.name
}

resource "azurerm_network_security_rule" "deny-in-all" {
  name                        = "d-in-all"
  priority                    = 4000
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name = azurerm_resource_group.group.name
  network_security_group_name = azurerm_network_security_group.nsg_default.name
}
