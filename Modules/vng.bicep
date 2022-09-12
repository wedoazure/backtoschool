param vnetName string
param location string
param date string 
param email string
param service string
param vnet string

var vngPIPName = '${vnetName}-vng-pip'
var vngName = '${vnetName}-vng'
var snetId = '${vnet}/subnets/GatewaySubnet'

resource vngPIP 'Microsoft.Network/publicIPAddresses@2022-01-01' = {
  name: vngPIPName
  location: location
  tags: {
    createdDate: date
    Owner: email
    Service: service
  }
  sku: {
    name: 'Basic'
  }
  properties: {
    publicIPAllocationMethod: 'Dynamic'
  }
}

resource vng 'Microsoft.Network/virtualNetworkGateways@2022-01-01' ={
  name: vngName
  location: location
  tags: {
    createdDate: date
    Owner: email
    Service: service
  }
  properties: {
    ipConfigurations: [
      {
        name: 'ipConf'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: snetId
          }
          publicIPAddress: {
            id: vngPIP.id
          }
        }
      }
    ]
    sku: {
      name: 'VpnGw1AZ'
      tier: 'VpnGw1AZ'
    }
    gatewayType: 'Vpn'
    vpnType: 'RouteBased'
    enableBgp: true
  }
}
