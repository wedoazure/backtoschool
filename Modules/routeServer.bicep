param vnetName string
param location string
param date string 
param email string
param service string

var rtrName = '${vnetName}-rtr'
var asn = 65000

resource rteSrv 'Microsoft.Network/virtualRouters@2022-01-01' = {
  name: rtrName
  location: location
  tags: {
    createdDate: date
    Owner: email
    Service: service
  }
  properties: {
    hostedGateway: {
      id: 'string'
    }
    hostedSubnet: {
      id: 'string'
    }
    virtualRouterAsn: asn
    virtualRouterIps: [
      'string'
    ]
  }
}
