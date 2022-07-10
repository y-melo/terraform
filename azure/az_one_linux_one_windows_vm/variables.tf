###############################################################################
#   VARIABLES
###############################################################################
variable "client" {
  type    = string
  default = "ehrz"
}
variable "azure_region" {
  type    = string
  default = "cc"
}

variable "allowed_ssh_ips" {
  type = list(string)
}
variable "allowed_http_ips" {
  type = list(string)
}

variable "solution" {
  description = "Solution/Application"
  type        = string
  default     = "Solution"
}
variable "vml_name" {
  description = "LINUX VM name (it wil be prefixed with vml-)"
  type        = string
}
variable "vmw_name" {
  description = "WINDOWS VM name (it wil be prefixed with vmw-)"
  type        = string
}

variable "username" {
  type    = string
  default = "ehrz"
}

variable "win_password" {
  type = string
  sensitive = true
  description = "Used only when creating windows VM"
}

variable "ssh_file_path" {
  type    = string
  default = "~/.ssh/id_rsa.pub"
}

variable "linux_publisher" {
  type    = string
  default = "Canonical" /* OpenLogic */
}
variable "linux_offer" {
  type    = string
  default = "UbuntuServer" /* CentOS */
}
variable "linux_sku" {
  type    = string
  default = "18_04-lts-gen2" /* 7_8-gen2 */
}

variable "linux_vm_size" {
  description = "Map of vm sizes to be used based on current name space"
  type        = string
  default     = "Standard_D2s_v4"
}

variable "win_publisher" {
  type    = string
  default = "MicrosoftWindowsServer" /* OpenLogic */
}
variable "win_offer" {
  type    = string
  default = "WindowsServer" /* CentOS */
}
variable "win_sku" {
  type    = string
  default = "2022-datacenter" /* 7_8-gen2 */
}

variable "win_vm_size" {
  description = "Map of vm sizes to be used based on current name space"
  type        = string
  default     = "Standard_D2s_v4"
}

variable "region_map" {
  description = "mapping for region shortcut"
  type        = map(string)
  default = {
    "ncus" = "northcentralus"
    "cus"  = "centralus"
    "ce"   = "canadaeast"
    "cc"   = "canadacentral"
  }
}

variable "extra_tags" {
  type    = map(string)
  default = {}
}

###############################################################################
#   LOCALS
###############################################################################

locals {

  env          = lower(terraform.workspace)
  location     = lookup(var.region_map, var.azure_region)
  indexpostfix = "01"

  group_name = upper("${var.client}-${var.azure_region}-${local.env}-${var.solution}-RG") # CLIENT-REGION-WORKSPACE-SOLUTION-RG
  # THLN-CE-CBHTST-ACS-RG
  network_address_prefix = "172.21.0.0/16"
  subnet_address_prefix = {
    "${local.env}" = "172.21.0.0/24"
    }

  vnet_name   = upper("${var.client}-${var.azure_region}-VNET-${local.indexpostfix}") # CLIENT-REGION-VNET-01
  subnet_name = lower("subnet-${local.env}")                                          # subnet-WORKSPACE

  vml_full_name = lower("vml-${var.vml_name}-${local.indexpostfix}")
  vmw_full_name = lower("vmw-${var.vmw_name}-${local.indexpostfix}") 

  ####################################################################
  common_tags = merge(
    {
      Environment     = local.env
      Deployment_type = "terraform"
      Solution = var.solution
    },
    var.extra_tags
  )
}
