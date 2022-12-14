param vnetNameFile string
param locationFile string
param dateNow string = utcNow('yyyy-MM-dd')
param emailFile string
param vnetAddressPrefixFile string
param serviceFile string
param admNameFile string
@secure()
param vmPasswordFile string
param vmSizeFile string


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
  dependsOn: [
    vnetMDL
  ]
  params: {
    location: locationFile
    date: dateNow
    email: emailFile
    service: serviceFile
    vnet: vnetMDL.outputs.net
    vnetName: vnetNameFile
    admName: admNameFile
    vmPassword: vmPasswordFile
    vmSize: vmSizeFile
  }
}

module natVMMDL 'Modules/vm.bicep' = {
  name: 'nat-vm-deploy'
  dependsOn: [
    vnetMDL
  ]
  params: {
    location: locationFile
    date: dateNow
    email: emailFile
    service: serviceFile
    vnet: vnetMDL.outputs.net
    vnetName: vnetNameFile
    admName: admNameFile
    vmPassword: vmPasswordFile
    vmSize: vmSizeFile
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
    peer: qugMDL.outputs.peerIP
  }
}
