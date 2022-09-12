param vnetNameFile string
param locationFile string
param dateNow string = utcNow('yyyy-MM-dd')
param emailFile string
param vnetAddressPrefixFile string
param monNameFile string
param serviceFile string
param admNameFile string
param vmPasswordFile string

module monMDL 'Modules/monitor.bicep' = {
  name: 'mon-deploy'
  params: {
    location: locationFile
    date: dateNow
    email: emailFile
    name: monNameFile
    service: serviceFile
  }
}

module vnetMDL 'Modules/network.bicep' = {
  name: 'vnet-deploy'
  params: {
    vnetName: vnetNameFile
    vnetAddress: vnetAddressPrefixFile
    location: locationFile
    date: dateNow
    email: emailFile
    service: serviceFile
    natGW: natGWMDL.outputs.natGW
  }
}

module qugMDL 'Modules/quagga.bicep' = {
  name: 'quagga-deploy'
  params: {
    location: locationFile
    date: dateNow
    email: emailFile
    service: serviceFile
    vnet: vnetMDL.outputs.net
    vnetName: vnetNameFile
    admName: admNameFile
    vmPassword: vmPasswordFile
  }
}


module bstMDL 'Modules/bastion.bicep' = {
  name: 'bst-deploy'
  dependsOn: [
    vnetMDL
  ]
  params: {
    vnetName: vnetNameFile
    location: locationFile
    date: dateNow
    email: emailFile
    vnet: vnetMDL.outputs.net
    service: serviceFile
  }
}

module natGWMDL 'Modules/natGateway.bicep' = {
  name: 'natgw-deploy'
  params: {
    vnetName: vnetNameFile
    location: locationFile
    date: dateNow
    email: emailFile
    service: serviceFile
  }
}

module rteSrvMDL 'Modules/routeServer.bicep' = {
  name: 'rte-srv-deploy'
  dependsOn: [
    vnetMDL
  ]
  params: {
    vnetName: vnetNameFile
    location: locationFile
    date: dateNow
    email: emailFile
    service: serviceFile
    vnet: vnetMDL.outputs.net
  }
}
