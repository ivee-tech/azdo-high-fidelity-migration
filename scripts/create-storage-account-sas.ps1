$rgName = 'devops-migration-rg'
$acctName = ($rgName + 'acct').Replace("-", "")
# $containerName = 'import' # data, import, scripts

# $storageAccount = Get-AzStorageAccount -ResourceGroupName $rgName `
#   -Name $acctName `
# $ctx = $storageAccount.Context
$acctKeys = $(az storage account keys list -g $rgName -n $acctName) | ConvertFrom-Json
$acctKey = $acctKeys[0]

$startTime = Get-Date
$st = $startTime.ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
$endTime = $startTime.AddHours(24.0)
$et = $endTime.ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
# New-AzStorageContainerSASToken -Container $containerName -Permission rwdl -StartTime $startTime -ExpiryTime $endTime -Context $ctx

az storage account generate-sas `
  --start $st `
  --expiry $et `
  --permissions rwl `
  --resource-types co `
  --services b `
  --account-key $acctKey.value `
  --account-name $acctName
