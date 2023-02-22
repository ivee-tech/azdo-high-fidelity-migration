$acctName = 'devopsmigrationrgacct'
$key = '<key>'
$fileName = '*.bak' # '<file>'
$filePath = 'C:\Data\Backup\' + $fileName
$containerName = 'data'
$sasToken = '***' # use create-storage-account-sas.ps1 script to generate a SAS token

# $ctx = New-AzStorageContext -StorageAccountName $acctName -StorageAccountKey $key
# Measure-Command {
#     Set-AzStorageBlobContent -File $filePath -Container $containerName -Blob $fileName -Context $ctx -Force
# }

Measure-Command {
    azcopy cp $filePath https://$($acctName).blob.core.windows.net/$($containerName)?$($sasToken)
}
