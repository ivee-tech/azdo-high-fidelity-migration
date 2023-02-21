$ids = @(
    ''
)

$users = New-Object System.Collections.Generic.List[System.Object]

$ids | ForEach-Object {
    $arr = $_.Split('\')
    $domain = $arr[0]
    $userName = $arr[1]
    $svr = (Get-ADDomain $domain -ErrorAction SilentlyContinue).InfrastructureMaster
    # Write-Output $domain, $svr, $userName
    $users.Add($(Get-ADUser -Identity $userName -ErrorAction SilentlyContinue))
}

$users | Select-Object DistinguishedName, Enabled, GivenName, Name, ObjectClass, ObjectGUID, SamAccountName, SID, Surname, UserPrincipalName | Export-Csv -Path C:\Data\TFS\historical-ids.csv

