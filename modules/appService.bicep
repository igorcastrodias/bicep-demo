param location string
param appServicePlanName string
param webAppName string

@allowed([
  'nonprod'
  'prod'
])
param environmentType string
var appServicePlanSkuName = (environmentType == 'prod') ? 'P1v2' : 'F1'

resource appServicePlan 'Microsoft.Web/serverfarms@2021-03-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: appServicePlanSkuName
  }
}

resource webApplication 'Microsoft.Web/sites@2021-03-01' = {
  name: webAppName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
  }
}


output webAppNameHostName string = webApplication.properties.defaultHostName
