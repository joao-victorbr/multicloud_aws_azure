# AWS e Azure Multi-Cloud Deploy com Terraform

# Cria um grupo de recursos na Azure
resource "azurerm_resource_group" "JVrg" {
  name     = "JV-resource-group"  # Nome do grupo de recursos
  location = "westus"              # Localização do grupo de recursos
}

# Cria uma rede virtual dentro do grupo de recursos
resource "azurerm_virtual_network" "JVvn" {
  name                = "jvVNet"                              # Nome da rede virtual
  resource_group_name = azurerm_resource_group.DSArg.name      # Associa a rede virtual ao grupo de recursos
  location            = azurerm_resource_group.DSArg.location  # Localização da rede virtual
  address_space       = ["10.0.0.0/16"]                        # Espaço de endereçamento da rede virtual
}

# Cria uma subnet dentro da rede virtual
resource "azurerm_subnet" "JVsn" {
  name                 = "jvSubnet"                         # Nome da subnet
  resource_group_name  = azurerm_resource_group.DSArg.name   # Associa a subnet ao grupo de recursos
  virtual_network_name = azurerm_virtual_network.DSAvn.name  # Associa a subnet à rede virtual
  address_prefixes     = ["10.0.1.0/24"]                     # Define o bloco CIDR para a subnet
}

# Cria um endereço IP público
resource "azurerm_public_ip" "JVip" {
  name                = "jvPublicIP"                          # Nome do endereço IP público
  location            = azurerm_resource_group.JVrg.location  # Localização do endereço IP público
  resource_group_name = azurerm_resource_group.JVrg.name      # Associa o IP público ao grupo de recursos
  allocation_method   = "Static"                              # Método de alocação do IP público
}

# Cria uma interface de rede
resource "azurerm_network_interface" "JVni" {
  name                = "jvNIC"                               # Nome da interface de rede
  location            = azurerm_resource_group.JVrg.location  # Localização da interface de rede
  resource_group_name = azurerm_resource_group.JVrg.name      # Associa a interface de rede ao grupo de recursos

  ip_configuration {
    name                          = "jvIPConfig"               # Nome da configuração de IP
    subnet_id                     = azurerm_subnet.JVsn.id     # Associa a configuração de IP à subnet
    private_ip_address_allocation = "Dynamic"                   # Método de alocação do endereço IP privado
    public_ip_address_id          = azurerm_public_ip.JVip.id  # Associa um endereço IP público à configuração de IP
  }
}

# Cria uma máquina virtual
resource "azurerm_virtual_machine" "JVvm" {
  name                  = "JV-deployed"                         # Nome da máquina virtual
  location              = azurerm_resource_group.JVrg.location  # Localização da máquina virtual
  resource_group_name   = azurerm_resource_group.JVrg.name      # Associa a máquina virtual ao grupo de recursos
  vm_size               = "Standard_B1s"                         # Especifica o tamanho da máquina virtual
  network_interface_ids = [azurerm_network_interface.JVni.id]   # Associa a interface de rede à máquina virtual

  storage_image_reference {
    publisher = "Canonical"     # Editor da imagem do sistema operacional
    offer     = "0001-com-ubuntu-server-focal"  # Oferta do sistema operacional
    sku       = "20_04-lts"     # SKU do sistema operacional
    version   = "latest"        # Versão do sistema operacional
  }

  os_profile {
    computer_name  = "jv-deployed"  # Nome do computador na máquina virtual
    admin_username = "jvadmin"      # Nome de usuário administrador
    admin_password = "Password123!"  # Senha do administrador
  }

  storage_os_disk {
    name              = "osdisk"       # Nome do disco do sistema operacional
    caching           = "ReadWrite"    # Tipo de caching para o disco
    create_option     = "FromImage"    # Opção de criação do disco
    managed_disk_type = "Premium_LRS"  # Tipo do disco gerenciado
  }

  os_profile_linux_config {
    disable_password_authentication = false  # Configuração de autenticação por senha
  }
}
