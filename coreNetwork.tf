resource "azurerm_resource_group" "tfm-coreNetwork" {
    name        = "tfm-coreNetwork"
    location    = "${var.loc}"
    tags        = "${var.tags}"
}

resource "azurerm_public_ip" "tfm-vpnGatewayPublicIp" {
    name                = "tfm-vpnGatewayPublicIp"
    location            = "${azurerm_resource_group.tfm-coreNetwork.location}"
    resource_group_name = "${azurerm_resource_group.tfm-coreNetwork.name}"
    tags                = "${azurerm_resource_group.tfm-coreNetwork.tags}"
}

resource "azurerm_virtual_network" "tfm-coreVNet" {
    name                = "tfm-coreVNet"
    location            = "${azurerm_resource_group.tfm-coreNetwork.location}"
    resource_group_name = "${azurerm_resource_group.tfm-coreNetwork.name}"
    tags                = "${azurerm_resource_group.tfm-coreNetwork.tags}"

    address_space       = ["192.168.0.0/16"]
    dns_servers         = ["1.1.1.1", "1.0.0.1"]
}

resource "azurerm_subnet" "tfm-trainingSubnet" {
    name                    = "tfm-trainingSubnet"
    resource_group_name     = "${azurerm_resource_group.tfm-coreNetwork.name}"
    virtual_network_name    = "${azurerm_virtual_network.tfm-coreVNet.name}"

    address_prefix          = "192.168.1.0/24"
}

resource "azurerm_subnet" "tfm-devSubnet" {
    name                   = "tfm-devSubnet"
    resource_group_name     = "${azurerm_resource_group.tfm-coreNetwork.name}"
    virtual_network_name    = "${azurerm_virtual_network.tfm-coreVNet.name}"

    address_prefix          = "192.168.2.0/24"
}

resource "azurerm_subnet" "tfm-gatewaySubnet" {
    name                    = "tfm-gatewaySubnet"
    resource_group_name     = "${azurerm_resource_group.tfm-coreNetwork.name}"
    virtual_network_name    = "${azurerm_virtual_network.tfm-coreVNet.name}"

    address_prefix          = "192.168.0.0/24"
}

# resource "azurerm_virtual_network_gateway" "tfm-vpnGateway" {
#     name                = "tfm-vpnGateway"
#     location            = "${azurerm_resource_group.tfm-coreNetwork.location}"
#     resource_group_name = "${azurerm_resource_group.tfm-coreNetwork.name}"
#     tags                = "${azurerm_resource_group.tfm-coreNetwork.tags}"
# 
#     type                = "Vpn"
#     vpn_type            = "RouteBased"
# 
#     sku                 = "Basic"
#     enable_bgp          = true
# 
#     ip_configuration {
#         name                            = "tfm-vpnGwConfig"
#         public_ip_address_id            = "${azurerm_public_ip.tfm-vpnGatewayPublicIp.id}"
#         private_ip_address_allocation   = "Dynamic"
#         subnet_id                       = "${azurerm_subnet.tfm-gatewaySubnet.id}"
#     }
# 
# }