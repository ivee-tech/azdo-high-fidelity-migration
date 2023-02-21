$ids = @(
    ''
)

$ids | ForEach-Object {
    Get-ADUser -Identity $_ -ErrorAction SilentlyContinue
}
