$rgName = 'devops9867'
$location = 'AustraliaEast'
$acctName = $rgName + 'acct'
$sku = 'Standard_LRS'
$containers = @('scripts', 'data', 'import')

$storageAccount = New-AzStorageAccount -ResourceGroupName $rgName `
  -Name $acctName `
  -SkuName $sku `
  -Location $location `

<#
$storageAccount = Get-AzStorageAccount -ResourceGroupName $rgName `
  -Name $acctName
#>
$ctx = $storageAccount.Context

$containers | foreach-object {
  $containerName = $_
  New-AzStorageContainer -Name $containerName -Context $ctx -Permission blob
}


