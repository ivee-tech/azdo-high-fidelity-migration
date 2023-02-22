$acctName = 'devopsmigrationrgacct'
$key = '<key>'
# $fileName = 'init-disk.ps1' # '<file>'
$fileName = '*.bacpac'
$filePath = 'C:\Data\Backup\' + $fileName
# $filePath = 'C:\s\azdo-high-fidelity-migration\scripts\' + $fileName
$containerName = 'data'
 # use create-storage-account-sas.ps1 script to generate a SAS token
$sasToken = '***'

# $ctx = New-AzStorageContext -StorageAccountName $acctName -StorageAccountKey $key
# Measure-Command {
#     Set-AzStorageBlobContent -File $filePath -Container $containerName -Blob $fileName -Context $ctx -Force
# }

Measure-Command {
    azcopy cp $filePath https://$($acctName).blob.core.windows.net/$($containerName)?$($sasToken)
}
