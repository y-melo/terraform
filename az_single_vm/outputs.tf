#############################################################################
# OUTPUTS
#############################################################################
output "group_name" {
  value = local.group_name
}

output "vm_ip"{
  value = azurerm_network_interface.vm_nic.ip_configuration[0].private_ip_address
}
output "ssh_connection"{
  value = "ssh ${var.username}@${azurerm_public_ip.pip.ip_address}"
}
