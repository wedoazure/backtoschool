param vnetName string
param location string
param date string 
param email string
param service string
param vnet string
@secure()
param vmPassword string
param admName string
param vmSize string

var vmName = '${vnetName}-qga'
var qgaPIPName = '${vmName}-pip'
var subId = '${vnet}/subnets/QuaggaSubnet'

resource qgaPIP 'Microsoft.Network/publicIPAddresses@2021-03-01' = {
  name: qgaPIPName
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

resource qgaNic 'Microsoft.Network/networkInterfaces@2022-01-01' = {
  name: '${vmName}-nic01'
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
          publicIPAddress: {
            id: qgaPIP.id
          }
          privateIPAllocationMethod: 'Static'
          privateIPAddress: '10.55.1.4'
          subnet: {
            id: subId
          }
        }
      }
    ]
  } 
}

resource qga 'Microsoft.Compute/virtualMachines@2022-03-01' = {
name: vmName
  location: location
  tags: {
    createdDate: date
    Owner: email
    Service: service
  }
  properties: {
    
    hardwareProfile: {
      vmSize: vmSize
    }
    osProfile: {
      computerName: vmName
      adminUsername: admName
      adminPassword: vmPassword
      linuxConfiguration: {
        provisionVMAgent: true
      }
    }
    storageProfile: {
      imageReference: {
        publisher: 'Canonical'
        offer: 'UbuntuServer'
        sku: '18_04-lts-gen2'
        version: 'latest'
      }
      osDisk: {
        name: '${vmName}-osdisk'
        caching: 'ReadWrite'
        createOption: 'FromImage'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: qgaNic.id
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
      }
    }
  }
}

output username string = admName
output peerIP string = qgaNic.properties.ipConfigurations[0].properties.privateIPAddress
