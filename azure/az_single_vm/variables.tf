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
variable "vm_name" {
  description = "VM name (it wil be prefixed with vm-)"
  type        = string
}

variable "username" {
  type    = string
  default = "ehrz"
}

variable "ssh_file_path" {
  type    = string
  default = "~/.ssh/id_rsa.pub"
}

variable "publisher" {
  type    = string
  default = "Canonical" /* OpenLogic */
}
variable "offer" {
  type    = string
  default = "UbuntuServer" /* CentOS */
}
variable "sku" {
  type    = string
  default = "18_04-lts-gen2" /* 7_8-gen2 */
}

variable "vm_size" {
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

  network_address_prefix = "172.20.0.0/16"
  subnet_address_prefix = {
    "${local.env}" = "172.20.0.0/24"
    }

  vnet_name   = upper("${var.client}-${var.azure_region}-VNET-${local.indexpostfix}") # CLIENT-REGION-VNET-01
  subnet_name = lower("subnet-${local.env}")                                          # subnet-WORKSPACE

  vm_full_name = lower("vm-${var.vm_name}-${local.indexpostfix}")

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
