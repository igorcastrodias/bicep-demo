param cosmosDBAccountName string = 'toyrnd-${uniqueString(resourceGroup().id)}'
@minValue(400)
param cosmosDBDatabaseThroughput int = 400
param storageAccountName string = 'stoaccbiceplolxvgwk57tpo'
param location string = resourceGroup().location

var cosmosDBDatabaseName = 'FlightTests'
var cosmosDBContainerName = 'FlightTests'
var cosmosDBContainerPartitionKey = '/droneId'
var logAnalyticsWorkspaceName = 'ToyLogs'
var cosmosDBAccountDiagnosticSettingsName = 'route-logs-to-log-analytics'
var storageAccountBlobDiagnosticSettingsName = 'route-logs-to-log-analytics'

resource cosmosDBAccount 'Microsoft.DocumentDB/databaseAccounts@2021-10-15' = {
  name: cosmosDBAccountName
  location: location
  properties: {
    databaseAccountOfferType: 'Standard'
    locations: [
      {
        locationName: location
      }
    ]
  }
}

resource comosDBDatabse 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2021-10-15' = {
  parent: cosmosDBAccount
  name: cosmosDBDatabaseName
  properties: {
    resource: {
      id: cosmosDBDatabaseName
    }
    options: {
      throughput: cosmosDBDatabaseThroughput
    }
  }

  resource container 'containers' = {
    name: cosmosDBContainerName
    properties: {
      resource: {
        id: cosmosDBContainerName
        partitionKey: {
          kind: 'Hash'
          paths: [
            cosmosDBContainerPartitionKey
          ]
        }
      }
      options: {
        
      }
    }
  }
}

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2021-12-01-preview' existing = {
  name: logAnalyticsWorkspaceName
}

resource cosmosDBAccountDiagnostics 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  scope: cosmosDBAccount
  name: cosmosDBAccountDiagnosticSettingsName
  properties: {
    workspaceId: logAnalyticsWorkspace.id
    logs: [
       {
         category: 'DataPlaneRequests'
         enabled: true
       }
    ]
  }
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-08-01' existing = {
  name: storageAccountName

  resource blobService 'blobServices' existing = {
    name: 'default'
  }
}

resource storageAccountBlobDiagnostics 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  scope: storageAccount::blobService
  name: storageAccountBlobDiagnosticSettingsName
  properties: {
    workspaceId: logAnalyticsWorkspace.id
    logs: [
      {
        category: 'StorageRead'
        enabled: true
      }
      {
        category: 'StorageWrite'
        enabled: true
      }
      {
        category: 'StorageDelete'
        enabled: true
      }
    ]
  }
}
