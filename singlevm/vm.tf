#Code to build out complete VM.
# See https://www.terraform.io/docs/providers/azurerm/r/virtual_machine.html fro syntax.

# Data source for the subnet that already exists
data "azurerm_subnet" "loc_env_vm_subnet" {
  name                 = "${var.subnet}"
  virtual_network_name = "${var.vnet}"
  resource_group_name  = "${var.subnet_rsg}"
}

# NIC
resource "azurerm_network_interface" "loc_env_vm_nic" {
  name                = "${var.vm_name}-nic"
  location            = "${var.location}"
  resource_group_name = "${var.rsg}"

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = "${data.azurerm_subnet.loc_env_vm_subnet.id}"
    private_ip_address_allocation = "dynamic"
  }

}

#VM
resource "azurerm_virtual_machine" "loc_env_vm" {
  name                  = "${var.vm_name}"
  location              = "${var.location}"
  resource_group_name   = "${var.rsg}"
  network_interface_ids = ["${azurerm_network_interface.loc_env_vm_nic.id}"]
  vm_size               = "${var.vm_size}"

  # Uncomment the line below to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true

  # Uncomment the line below to delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

  storage_os_disk {
    name              = "${var.vm_name}-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "${var.vm_disk_sku}"
  }

  os_profile {
    computer_name  = "${var.vm_name}"
    admin_username = "${lower(var.vm_name)}-adm"
    admin_password = "${var.admin_password}"
  }

  os_profile_windows_config {
    provision_vm_agent = true
    timezone           = "${var.vm_timezone}"
  }

  storage_data_disk {
    name              = "${var.vm_name}-disk1"
    create_option     = "Empty"
    caching           = "None"
    managed_disk_type = "${var.vm_disk_sku}"
    disk_size_gb      = 128
    lun               = 0
  }

  storage_data_disk {
    name              = "${var.vm_name}-disk2"
    create_option     = "Empty"
    caching           = "None"
    managed_disk_type = "${var.vm_disk_sku}"
    disk_size_gb      = 128
    lun               = 1
  }

}

output "loc_env_vm_name" {
  value = "${azurerm_virtual_machine.loc_env_vm.name}"
}

output "loc_env_vm_username" {
  value = "${lower(var.vm_name)}-adm"
}

output "loc_env_vm_password" {
  value = "${var.admin_password}"
}

output "loc_env_vm_private_ips" {
  value = "${azurerm_network_interface.loc_env_vm_nic.private_ip_address}"
}

output "loc_env_vm_rsg" {
  value = "${azurerm_virtual_machine.loc_env_vm.resource_group_name}"
}

output "loc_env_vm_location" {
  value = "${azurerm_virtual_machine.loc_env_vm.location}"
}
