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

var vmName = '${vnetName}-nat'
var vmPublicIpName = '${vnetName}-nat-ip'
var subId = '${vnet}/subnets/OutboundSubnet'

resource natVMPIP 'Microsoft.Network/publicIPAddresses@2022-01-01' = {
  name: vmPublicIpName
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

resource natNic 'Microsoft.Network/networkInterfaces@2022-01-01' = {
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
            id: natVMPIP.id
          }
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: subId
          }
        }
      }
    ]
  } 
}

resource nat 'Microsoft.Compute/virtualMachines@2022-03-01' = {
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
          id: natNic.id
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

