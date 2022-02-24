@description('Specifies the location for resources.')
param location string = resourceGroup().location

@description('Environments Type for resources.')
@allowed([
  'nonprod'
  'prod'
])
param environmentType string

var storageAccountSkuName = (environmentType == 'prod') ? 'Standard_GRS' : 'Standard_LRS'
var appServicePlanName = 'appServicePlan${uniqueString(resourceGroup().id)}'
var webAppName = 'webAppBicepDemo${uniqueString(resourceGroup().id)}'

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-08-01' = {
  name: 'stoaccbicep${uniqueString(resourceGroup().id)}'
  location: location
  sku: {
    name: storageAccountSkuName
  }
  kind: 'StorageV2'
}

module appService 'modules/appService.bicep' = {
  name: 'appService'
  params: {
    appServicePlanName: appServicePlanName
    environmentType: environmentType
    location: location
    webAppName: webAppName
  }
}

output appServiceAppHostName string = appService.outputs.webAppNameHostName
