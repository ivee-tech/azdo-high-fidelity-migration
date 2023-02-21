# $proxyAddress = 'http://127.0.0.1:8888' # Fiddler
$proxyAddress = 'http://<address>:<port>'
$proxyAddress = 'http://<address>:<port>'
$proxy = [System.Net.WebProxy]::new($proxyAddress)
[System.Net.WebRequest]::DefaultWebProxy = $proxy
[System.Net.WebRequest]::DefaultWebProxy.Credentials = [System.Net.CredentialCache]::DefaultCredentials
