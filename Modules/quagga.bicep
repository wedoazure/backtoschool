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
var subId = '${vnet}/subnets/QuaggaSubnet'


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
          privateIPAllocationMethod: 'Dynamic'
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
        patchSettings: {
          patchMode: 'AutomaticByPlatform'
        }
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
