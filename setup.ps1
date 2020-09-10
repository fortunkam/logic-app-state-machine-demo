# Create Resource group
$rg = "workflow-logic-app-demo"
$loc = "uksouth"
$storageaccountname = -join ((97..122) | Get-Random -Count 15 | % {[char]$_})

az group create -n $rg --location $loc

# Create storage account
az storage account create -g $rg -n $storageaccountname

# Get the connection strings 
$connectionString = $(az storage account show-connection-string -g $rg -n $storageaccountname --query connectionString -o tsv)
$storageAccountKey = $(az storage account keys list -g $rg -n $storageaccountname --query [0].value -o tsv)

# Create tables
az storage table create -n "logs" --account-key $storageAccountKey --account-name $storageaccountname
az storage table create -n "errors" --account-key $storageAccountKey --account-name $storageaccountname
az storage table create -n "callbackurls" --account-key $storageAccountKey --account-name $storageaccountname

# Create a logic app connection

az deployment group create --resource-group $rg `
    --template-file .\arm-templates\tableconnection.json `
    --parameters tableAccountName=$storageaccountname tableAccountKey=$storageAccountKey

# Deploy Subscribe Logic App 

$subscribeUrl = $(az deployment group create --resource-group $rg --template-file .\arm-templates\SubscribeToWebhookLogicApp.json --query properties.outputs.logicAppUrl.value -o tsv)

$encodedSubscribeUrl = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes($subscribeUrl))
$workflowUrl = $(az deployment group create --resource-group $rg --template-file .\arm-templates\BaseWorkflowLogicApp.json --parameters subscriberLogicAppUrl="$encodedSubscribeUrl" --query properties.outputs.logicAppUrl.value -o tsv)

# Deploy the other logic apps

$advanceUrl = $(az deployment group create --resource-group $rg --template-file .\arm-templates\AdvanceWorkflowLogicApp.json --query properties.outputs.logicAppUrl.value -o tsv)


Write-Host "Advance Workflow Url"
Write-Host $advanceUrl

Write-Host "Base or Start Workflow Url"
Write-Host $workflowUrl