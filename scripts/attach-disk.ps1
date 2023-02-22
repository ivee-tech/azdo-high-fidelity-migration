$rgName = 'devops-migration-rg'
$vmName = 'sqlvm'
$location = 'AustraliaEast' 
$storageType = 'Premium_LRS'
$dataDiskName = $vmName + '_datadisk1'
$diskSize = 2048 # 2TB

<#
$diskConfig = New-AzDiskConfig -SkuName $storageType -Location $location -CreateOption Empty -DiskSizeGB $diskSize
$dataDisk1 = New-AzDisk -DiskName $dataDiskName -Disk $diskConfig -ResourceGroupName $rgName

$vm = Get-AzVM -Name $vmName -ResourceGroupName $rgName 
$vm = Add-AzVMDataDisk -VM $vm -Name $dataDiskName -CreateOption Attach -ManagedDiskId $dataDisk1.Id -Lun 1

Update-AzVM -VM $vm -ResourceGroupName $rgName
#>

az vm disk attach -g $rgName --vm-name $vmName --name $dataDiskName --new --sku $storageType --size-gb $diskSize
