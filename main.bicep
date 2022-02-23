@description('Specifies the location for resources.')
param location string = 'eastus'

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-08-01' = {
  name: 'stoaccountbicepdemo'
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
}

resource appServicePlan 'Microsoft.Web/serverfarms@2021-03-01' = {
  name: 'appServicePlan'
  location: location
  sku: {
    name: 'F1'
  }
}

resource webApplication 'Microsoft.Web/sites@2021-03-01' = {
  name: 'webAppBicepDemo'
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
  }
}
