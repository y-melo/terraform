# TERRAFORM

## Description

Creates the minimal infrastructure in azure and runs a linux vm with a public ip.

Resource group:
  Vnet
    subnet
  NSG
  NSG association
  PublicIP
  VM Linux
    NIC
    OS disk
  VM Windows
    NIC
    OS disk

> The NSG will block any incoming traffic to the vm that's not in the allowed_ips list:  
> `allowed_ssh_ips`  
> `allowed_http_ips`  

## Variables

```tfvars
| Variable         | Type        |
|------------------|-------------|
| client           | string      |
| azure_region     | string      |
| allowed_ssh_ips  | list        |
| allowed_http_ips | list        |
| solution         | string      |
| vml_name          | string      |
| vmw_name          | string      |
| username         | string      |
| win_password     | string      |
| ssh_file_path    | string      |
| linux_publisher        | string      |
| linux_offer            | string      |
| linux_sku              | string      |
| linux_vm_size          | string      |
| win_publisher        | string      |
| win_offer            | string      |
| win_sku              | string      |
| win_vm_size          | string      |
| region_map       | map(string) |
| extra_tags       | map(string) |

> See: terraform.tfvars

```

## Terraform help commands

```sh
az account set --subscription '<SUBSCRIPTION_NAME>'

terraform init

terraform workspace list
terraform workspace new dev

terraform plan -out dev.tfplan
terraform apply dev.tfplan

terraform state list

terraform destroy
```

To create a **linux** machine you can have a file `linux.tfvars`

```tfvars
publisher = "Canonical"
offer = "0001-com-ubuntu-server-jammy"
sku = "22_04-lts"
vm_name = "linux"
```

> terraform plan -out linux.plan --var-file=linux.tfvars

To create a **windows** machine you can have a file `linux.tfvars`

```tfvars
vm_name      = "windows"
win_password = "Windows_Password"
publisher    = "MicrosoftWindowsServer"
offer        = "WindowsServer"
sku          = "2022-datacenter"
```

> terraform plan -out windows.plan --var-file=windows.tfvars

## Reference

[Terraform Azurerm docs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
