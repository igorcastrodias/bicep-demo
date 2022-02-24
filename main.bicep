@description('Specifies the location for resources.')
param location string = resourceGroup().location

@description('Environments Type for resources.')
@allowed([
  'nonprod'
  'prod'
])
param environmentType string

var storageAccountSkuName = (environmentType == 'prod') ? 'Standard_GRS' : 'Standard_LRS'
var appServicePlanSkuName = (environmentType == 'prod') ? 'P2V3' : 'F1'

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-08-01' = {
  name: 'stoaccountbicepdemo${uniqueString(resourceGroup().id)}'
  location: location
  sku: {
    name: storageAccountSkuName
  }
  kind: 'StorageV2'
}

resource appServicePlan 'Microsoft.Web/serverfarms@2021-03-01' = {
  name: 'appServicePlan${uniqueString(resourceGroup().id)}'
  location: location
  sku: {
    name: appServicePlanSkuName
  }
}

resource webApplication 'Microsoft.Web/sites@2021-03-01' = {
  name: 'webAppBicepDemo${uniqueString(resourceGroup().id)}'
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
  }
}
