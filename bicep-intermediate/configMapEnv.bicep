@allowed([
  'Production'
  'Test'
])
param environmentType string = 'Test'
param location string = resourceGroup().location

var appServicePlanName = 'hostingplan${uniqueString(resourceGroup().id)}'

var environmentConfigurationMap = {
  Production: {
    appServicePlan: {
      sku: {
        name: 'P2V3'
        capacity: 3
      }
    }
    storageAccount: {
      sku: {
        name: 'ZRS'
      }
    }
  }
  Test: {
    appServicePlan: {
      sku: {
        name: 'S2'
        capacity: 1
      }
    }
    storageAccount: {
      sku: {
        name: 'LRS'
      }
    }
  }
}

resource appServicePlan 'Microsoft.Web/serverfarms@2020-06-01' = {
  name: appServicePlanName
  location: location
  sku: environmentConfigurationMap[environmentType].appServicePlan.sku
}
