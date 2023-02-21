$acctName = 'devops9867'
$key = '<key>'
$fileName = '<file>'
$filePath = 'C:\TFS\' + $fileName
$containerName = 'data'

$ctx = New-AzStorageContext -StorageAccountName $acctName -StorageAccountKey $key
Measure-Command {
    Set-AzStorageBlobContent -File $filePath -Container $containerName -Blob $fileName -Context $ctx -Force
}
