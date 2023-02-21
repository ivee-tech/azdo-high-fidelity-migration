$rgName = 'devops9867'
$acctName = $rgName + 'acct'
$containerName = 'scripts'
$fileName = 'add-azcopy-path.ps1'

$storageAccount = Get-AzStorageAccount -ResourceGroupName $rgName `
  -Name $acctName `

$ctx = $storageAccount.Context

Set-AzStorageBlobContent -File $fileName `
  -Container $containerName `
  -Blob $fileName `
  -Context $ctx -Force

<#
./AzCopy `
    /Source:C:\Sources\TFS\Import `
    /Dest:https://devops9867acct.blob.core.windows.net/scripts `
    /DestKey: $key`
    /Pattern:"init-disk.ps1"
#>
