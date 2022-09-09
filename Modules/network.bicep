param vnetName string
param location string
param vnetAddress string
param date string 
param email string
param service string

var firstOutput = split(vnetAddress, '.' )
var mask1 = firstOutput[0]
var mask2 = firstOutput[1]

var sub1 = '${mask1}.${mask2}.250.0/26'
var sub2 = '${mask1}.${mask2}.1.0/24'
var sub3 = '${mask1}.${mask2}.255.0/24'


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
        name: 'WindowsSubnet'
        properties: {
          addressPrefix: sub2
          routeTable: {
            id: rtDefault.id
         }
         networkSecurityGroup: {
          id: nsgDefault.id
       }
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
    ]
  }
}

output net string = virtualNetwork.id
output rt string = rtDefault.name
