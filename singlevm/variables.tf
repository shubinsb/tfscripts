/* Configure Azure Provider and declare all the Variables that will be used in Terraform configurations */
provider "azurerm" {
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  tenant_id       = "${var.tenant_id}"
}

variable "subscription_id" {
  description = "Enter Subscription ID for provisioning resources in Azure"
}

variable "client_id" {
  description = "Enter Client ID for Application created in Azure AD"
}

variable "client_secret" {
  description = "Enter Client secret for Application in Azure AD"
}

variable "tenant_id" {
  description = "Enter Tenant ID / Directory ID of your Azure AD. Run Get-AzureSubscription to know your Tenant ID"
}

variable "location" {
  description = "Azure region for the environment."
  default     = "Central USQ"
}

############
# VM Details
############

variable "admin_password" {
  description = "password for all VMs"
}

variable "vm_name" {
  description = "name for the VM"
  default     = ""
}

variable "vm_size" {
  description = "Size of the VM you want to create"
  default     = ""
}

variable "vm_disk_sku" {
  description = "Type of disk to use. Either Standard_LRS or Premium_LRS."
  default     = "Standard_LRS"
}

variable "vm_timezone" {
  description = "Timezone to set the OS to using Microsoft Tiemzone Index values. See https://support.microsoft.com/en-gb/help/973627/microsoft-time-zone-index-values for values (2nd column)."
  default     = "UTC"
}
