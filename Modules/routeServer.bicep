param vnetName string
param location string
param date string 
param email string
param service string
param vnet string
param peer string

var rtrName = '${vnetName}-rtr'
var rtrPIPName = '${vnetName}-rtr-pip'
var snetId = '${vnet}/subnets/RouteServerSubnet'

resource rtrPIP 'Microsoft.Network/publicIPAddresses@2021-03-01' = {
  name: rtrPIPName
  location: location
  tags: {
    createdDate: date
    Owner: email
    Service: service
  }
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

resource rtrSrv 'Microsoft.Network/virtualHubs@2022-01-01' = {
  name: rtrName
  location: location
  tags: {
    createdDate: date
    Owner: email
    Service: service
  }
  
  properties: {
    sku: 'Standard'
  }
}

resource rtrIP  'Microsoft.Network/virtualHubs/ipConfigurations@2022-01-01' = {
  name: 'ipconfig1'
  parent: rtrSrv
  properties: {
    subnet:{
      id: snetId
    }
    publicIPAddress: {
      id: rtrPIP.id
    }
  }
}

resource rtrBgp 'Microsoft.Network/virtualHubs/bgpConnections@2022-01-01' = {
  name: 'bgp1'
  parent: rtrSrv
  properties: {
    peerAsn: 65001
    peerIp: peer
  }
}
