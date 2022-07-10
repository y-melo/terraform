#############################################################################
# OUTPUTS
#############################################################################
output "group_name" {
  value = local.group_name
}
output "vm_name" {
  value = local.vm_full_name
}

output "internal_ip"{
  value = azurerm_network_interface.vm_nic.ip_configuration[0].private_ip_address
}

output "external_ip"{
  value = azurerm_public_ip.pip.ip_address
}
output "username"{
  value = var.username
}

output "allowed_ssh_ips" {
  value = var.allowed_ssh_ips
}