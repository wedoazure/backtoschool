param vnetName string
param location string
param date string 
param email string
param service string

var ngwPIPName = '${vnetName}-ngw-pip'
var ngwName = '${vnetName}-ngw'

resource ngwPIP 'Microsoft.Network/publicIPAddresses@2022-01-01' = {
  name: ngwPIPName
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

resource ngw 'Microsoft.Network/natGateways@2022-01-01' = {
  name: ngwName
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
    publicIpAddresses: [
      {
        id: ngwPIP.id
      }
    ]
    
    idleTimeoutInMinutes: 4
  }
}


output natGW string = ngw.id
