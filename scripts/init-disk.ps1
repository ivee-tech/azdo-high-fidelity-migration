$disks = Get-Disk | Where partitionstyle -eq 'raw' | sort number

$disk = $disks[0]

$driveLetter = "Z"
$label = "DevOpsData"

$disk | 
Initialize-Disk -PartitionStyle MBR -PassThru |
New-Partition -UseMaximumSize -DriveLetter $driveLetter |
Format-Volume -FileSystem NTFS -NewFileSystemLabel $label -Confirm:$false -Force
