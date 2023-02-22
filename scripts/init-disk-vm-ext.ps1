$location = "AustraliaEast"
$rgName = "devops-migration-rg"
$vmName = "sqlvm"
$acctName = ($rgName + "acct").Replace("-", "")
$key = "<storage account key>"
$containerName = "scripts"
$scriptName = "InitDiskDevOpsData"
$fileName = "init-disk.ps1"

$acctKeys = $(az storage account keys list -g $rgName -n $acctName) | ConvertFrom-Json
$acctKey = $acctKeys[0]

Set-AzVMCustomScriptExtension -ResourceGroupName $rgName -Location $location -VMName $vmName -Name $scriptName `
    -TypeHandlerVersion "1.4" -StorageAccountName $acctName -StorageAccountKey $acctKey.value `
    -FileName $fileName -ContainerName $containerName -Run $fileName

# az vm extension set -n customScript --publisher Microsoft.Azure.Extensions --ids {vm_id}