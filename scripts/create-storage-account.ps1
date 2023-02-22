$rgName = 'devops-migration-rg'
$location = 'AustraliaEast'
$acctName = ($rgName + 'acct').Replace("-", "")
$sku = 'Standard_LRS'
$containers = @('scripts', 'data', 'import')

# $storageAccount = New-AzStorageAccount -ResourceGroupName $rgName `
#   -Name $acctName `
#   -SkuName $sku `
#   -Location $location `
az storage account create -n $acctName -g $rgName -l $location --sku $sku

<#
$storageAccount = Get-AzStorageAccount -ResourceGroupName $rgName `
  -Name $acctName
#>
# $ctx = $storageAccount.Context
$acctKeys = $(az storage account keys list -g $rgName -n $acctName) | ConvertFrom-Json
$acctKey = $acctKeys[0]
$containers | ForEach-Object {
  $containerName = $_
  # New-AzStorageContainer -Name $containerName -Context $ctx -Permission blob
  az storage container create --name $containerName `
    --account-key $acctKey.value `
    --account-name $acctName
}


