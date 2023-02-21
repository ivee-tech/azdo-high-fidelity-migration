$rgName = 'devops9867'
$acctName = $rgName + 'acct'
$containerName = 'import'

$storageAccount = Get-AzStorageAccount -ResourceGroupName $rgName `
  -Name $acctName `

$ctx = $storageAccount.Context

$startTime = Get-Date
$endTime = $startTime.AddHours(24.0)
New-AzStorageContainerSASToken -Container $containerName -Permission rwdl -StartTime $startTime -ExpiryTime $endTime -Context $ctx