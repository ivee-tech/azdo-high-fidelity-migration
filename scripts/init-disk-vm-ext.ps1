$location = "AustraliaEast"
$rgName = "devops9867"
$vmName = "sqlvm"
$acctName = $rgName + "acct"
$key = "<storage account key>"
$containerName = "scripts"
$scriptName = "InitDiskDevOpsData"
$fileName = "init-disk.ps1"

Set-AzVMCustomScriptExtension -ResourceGroupName $rgName -Location $location -VMName $vmName -Name $scriptName `
    -TypeHandlerVersion "1.4" -StorageAccountName $acctName -StorageAccountKey $key `
    -FileName $fileName -ContainerName $containerName
