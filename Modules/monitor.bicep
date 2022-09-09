param location string
param date string 
param email string
param name string
param service string

resource law 'Microsoft.OperationalInsights/workspaces@2021-06-01' = {
  name: name
  location: location
  tags: {
    createdDate: date
    Owner: email
    Service: service
  }
  properties: {
    sku: {
      name: 'PerGB2018'
    }
  }
}

output workspace string = law.id
