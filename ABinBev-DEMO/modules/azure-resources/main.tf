 provider "azurerm" {
   features {}
 }

#Create a Resource Group

resource "azurerm_resource_group" "rg" {
  name     = var.azure_resource_group
  location = var.azure_location
 }

#Create Virtual Network

resource "azurerm_virtual_network" "vnet_1" {
  resource_group_name = azurerm_resource_group.rg.name
  name                = var.azure_vnet_name
  address_space       = [var.azure_vnet_cidr]
  location            = azurerm_resource_group.rg.location
}


resource "azurerm_subnet" "subnet-1" {
  address_prefixes     = [var.azure_subnet_cidr]
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet_1.name
  name                 = var.azure_subnet_name
  depends_on           = [azurerm_virtual_network.vnet_1]
}



# Create a Public IP
resource "azurerm_public_ip" "publicip" {
  allocation_method = "Dynamic"
  name = "publicip_1"
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
}


resource "azurerm_network_interface" "nic_1" {
  name                = "nic_1"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  ip_configuration {
    name                          = "nic_ip"
    subnet_id                     = azurerm_subnet.subnet_1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.publicip.id
  }
  depends_on = [
    azurerm_virtual_network.vnet_1,
    azurerm_public_ip.publicip
  ]
}

resource "azurerm_network_security_group" "nsg" {
  name                = var.nsg_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "allow_ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "allow_http"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "allow_rdp"
    priority                   = 102
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# resource "azurerm_public_ip" "publicip" {
#   name                = "vmpublicip"
#   resource_group_name = azurerm_resource_group.rg.name
#   location            = azurerm_resource_group.rg.location
#   allocation_method   = "Dynamic"

#   tags = {
#     environment = "ABinBev-Demo"
#   }
# }

# resource "azurerm_network_interface" "vnetaanic" {
#   name                = "vnetaanic"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name

#   ip_configuration {
#     name                          = "vnetaanic"
#     subnet_id                     = azurerm_subnet.subnet-1-VNET_AA.id
#     private_ip_address_allocation = "Dynamic"
#     public_ip_address_id          = azurerm_public_ip.publicip.id
#   }
# }

# resource "azurerm_virtual_machine" "test" {
#   name                  = "app6vneta"
#   location              = azurerm_resource_group.rg.location
#   resource_group_name   = azurerm_resource_group.rg.name
#   network_interface_ids = [azurerm_network_interface.vnetaanic.id]
#   vm_size                  = "Standard_B2s"


#   storage_image_reference {
#     publisher = "Canonical"
#     offer     = "0001-com-ubuntu-server-focal"
#     sku       = "20_04-lts"
#     version   = "latest"
#   }

#   storage_os_disk {
#     name                 = "myOsDisk"
#     caching              = "ReadWrite"
#     create_option        = "FromImage"
#     managed_disk_type    = "Standard_LRS"
#   }

#   os_profile {
#     computer_name  = "vnetapp6"
#     admin_username = "ABinBev"
#     admin_password = "ABinBev@12345"
#   }

# os_profile_linux_config {
#     disable_password_authentication = false
#   }
# }


# tls for ssh key
resource "tls_private_key" "linux_vm_key" {
  algorithm = "RSA"
  rsa_bits = 4096
}

# # save key in our machine
# resource "azurerm_ssh_public_key" "example" {
#   name                = var.azure_server_key_pair_name
#   resource_group_name = azurerm_resource_group.rg_iac.name
#   location            = azurerm_resource_group.rg_iac.location
#   public_key          = tls_private_key.linux_vm_key.public_key_openssh
#   provisioner "local-exec"{
#   command = "echo '${tls_private_key.linux_vm_key.private_key_pem}' > ./${var.azure_server_key_pair_name}.pem"
# }
# }


# Create a Subnet
resource "azurerm_subnet" "subnet_1" {
  address_prefixes     = [var.azure_subnet_cidr]
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet_1.name
  name                 = var.azure_subnet_name
  depends_on = [
    azurerm_virtual_network.vnet_1
  ]
}


# # Create a VM  ##### 


resource "azurerm_linux_virtual_machine" "vm" {
  name                  = var.azure_instance_name
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.nic_1.id]
  size                  = var.azure_vm_size

  admin_username = "linuxuser"
  # custom_data = base64encode(data.template_file.apache_install.rendered)
  admin_ssh_key {
    username   = "linuxuser"
    public_key = tls_private_key.linux_vm_key.public_key_openssh
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"

  }
}
