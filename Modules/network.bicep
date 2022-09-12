param vnetName string
param location string
param vnetAddress string
param date string 
param email string
param service string
param natGW string

var firstOutput = split(vnetAddress, '.' )
var mask1 = firstOutput[0]
var mask2 = firstOutput[1]

var sub1 = '${mask1}.${mask2}.250.0/26'
var sub2 = '${mask1}.${mask2}.1.0/24'
var sub3 = '${mask1}.${mask2}.255.0/24'
var sub4 = '${mask1}.${mask2}.254.0/24'
var sub5 = '${mask1}.${mask2}.123.0/24'
var sub6 = '${mask1}.${mask2}.222.0/24'


resource rtDefault 'Microsoft.Network/routeTables@2021-02-01' = {
  name: '${vnetName}-default-rt'
  location: location
  tags: {
    createdDate: date
    Owner: email
    Service: service
  }
}

resource nsgDefault 'Microsoft.Network/networkSecurityGroups@2021-02-01' = {
  name: '${vnetName}-default-nsg'
  location: location
  tags: {
    createdDate: date
    Owner: email
    Service: service
  }
}

resource nsgSSHRule 'Microsoft.Network/networkSecurityGroups/securityRules@2021-02-01' = {
  name: '${vnetName}-default-nsg-SSHRule'
  parent: nsgDefault
  properties: {
    access: 'Allow'
    description: 'Allow SSH'
    destinationAddressPrefix: '*'
    destinationPortRange: '22'
    direction: 'Inbound'
    priority: 105
    protocol: 'Tcp'
    sourceAddressPrefix: '*'
    sourcePortRange: '*'
  }
}

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2021-02-01' = {
  name: vnetName
  location: location
  tags: {
    createdDate: date
    Owner: email
    Service: service
  }
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetAddress
      ]
    }
    subnets: [
      {
        name: 'GatewaySubnet'
        properties: {
          addressPrefix: sub6
        }
      }
      {
        name: 'QuaggaSubnet'
        properties: {
          addressPrefix: sub2
        }
      }
      {
        name: 'AzureBastionSubnet'
        properties: {
          addressPrefix: sub3
        }
      }
      {
        name: 'RouteServerSubnet'
        properties: {
          addressPrefix: sub1
        }
      }
      {
        name: 'OutboundSubnet'
        properties: {
          addressPrefix: sub4
          natGateway: {
          id: natGW
          }
        }
      }
      {
        name: 'ASPSubnet'
        properties: {
          addressPrefix: sub5
           routeTable: {
            id: rtDefault.id
           }
           delegations: [
            {
              name: 'Microsoft.Web/serverFarms'
              properties: {
                serviceName: 'Microsoft.Web/serverFarms'
              }
            }
          ]
        }
      }
    ]
  }
}


output net string = virtualNetwork.id
output rt string = rtDefault.name
