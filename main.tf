# Create a resource group if it doesn't exist
resource "azurerm_resource_group" "myterraformresource_group" {
    name     = var.resourcegroup
    location = var.location

    tags = {
        environment = "Terraform Demo"
    }
}

# Create virtual network
resource "azurerm_virtual_network" "myterraformnetwork" {
    name                = var.vnetname
    address_space       = ["10.0.0.0/16"]
    location            = azurerm_resource_group.myterraformresource_group.location
    resource_group_name = azurerm_resource_group.myterraformresource_group.name

    tags = {
        environment = "Terraform Demo"
    }
}

# Create subnet
resource "azurerm_subnet" "myterraformsubnet" {
    name                 = var.subnet
    resource_group_name  = azurerm_resource_group.myterraformresource_group.name
    virtual_network_name = azurerm_virtual_network.myterraformnetwork.name
    address_prefixes       = ["10.0.1.0/24"]
}

# Create public IPs
resource "azurerm_public_ip" "myterraformpublicip" {
    name                         = var.publicipname
    location                     = azurerm_resource_group.myterraformresource_group.location
    resource_group_name          = azurerm_resource_group.myterraformresource_group.name
    allocation_method            = "Dynamic"

    tags = {
        environment = "Terraform Demo"
    }
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "myterraformnsg" {
    name                = "myNetworkSecurityGroup"
    location            = azurerm_resource_group.myterraformresource_group.location
    resource_group_name = azurerm_resource_group.myterraformresource_group.name

    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    tags = {
        environment = "Terraform Demo"
    }
}

# Create network interface
resource "azurerm_network_interface" "myterraformnic" {
    name                      = "myNIC"
    location                  = azurerm_resource_group.myterraformresource_group.location
    resource_group_name       = azurerm_resource_group.myterraformresource_group.name

    ip_configuration {
        name                          = "myNicConfiguration"
        subnet_id                     = azurerm_subnet.myterraformsubnet.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip.myterraformpublicip.id
    }

    tags = {
        environment = "Terraform Demo"
    }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "example" {
    network_interface_id      = azurerm_network_interface.myterraformnic.id
    network_security_group_id = azurerm_network_security_group.myterraformnsg.id
}


# Create storage account for boot diagnostics
resource "azurerm_storage_account" "mystorageaccount" {
    name                        = var.storageaccountname
    resource_group_name         = azurerm_resource_group.myterraformresource_group.name
    location                    = azurerm_resource_group.myterraformresource_group.location
    account_tier                = "Standard"
    account_replication_type    = "LRS"

    tags = {
        environment = "Terraform Demo"
    }
}


# Create virtual machine
resource "azurerm_linux_virtual_machine" "myterraformvm" {
    name                  = var.vmname
    location              = azurerm_resource_group.myterraformresource_group.location
    resource_group_name   = azurerm_resource_group.myterraformresource_group.name
    network_interface_ids = [azurerm_network_interface.myterraformnic.id]
    size                  = var.vmsize

    os_disk {
        name              = "myOsDisk"
        caching           = "ReadWrite"
        storage_account_type = "Premium_LRS"
    }

    source_image_reference {
        publisher = var.publisher
        offer     = var.offer
        sku       = var.sku
        version   = var.Osversion
    }

    computer_name  = "myvm"
    admin_username = var.adminusername
    admin_password = var.adminpassword
    disable_password_authentication = false
    

    
    boot_diagnostics {
        storage_account_uri = azurerm_storage_account.mystorageaccount.primary_blob_endpoint
    }

    tags = {
        environment = "Terraform Demo"
    }
}