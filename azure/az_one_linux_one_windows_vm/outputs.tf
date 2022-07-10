#############################################################################
# OUTPUTS
#############################################################################
output "group_name" {
  value = local.group_name
}
output "vm_names" {
  value = "Linux: ${local.vml_full_name} | Win: ${local.vmw_full_name}"
}

output "internal_ips"{
  value = [
   "Linux:    ${azurerm_network_interface.vml_nic.ip_configuration[0].private_ip_address}",
    "Windows: ${azurerm_network_interface.vmw_nic.ip_configuration[0].private_ip_address}"
    ]
}

output "external_ips"{
  value = [
    "Linux:   ${azurerm_public_ip.pipl.ip_address}",
    "Windows: ${azurerm_public_ip.pipw.ip_address}",
    ]
}
output "username"{
  value = var.username
}

#output "ssh_connection"{
#  value = var.publisher == "MicrosoftWindowsServer" ? "RDP: host=${azuremrm_public_ip.pip.ip_address} user=${var.username} port=3389" : "ssh ${var.username}@${azurerm_public_ip.pip.ip_address}"
#}

output "allowed_ssh_ips" {
  value = var.allowed_ssh_ips
}
