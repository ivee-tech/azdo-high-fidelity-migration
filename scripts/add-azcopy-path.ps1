$env:Path += ";C:\Program Files (x86)\Microsoft SDKs\Azure\AzCopy"
[Environment]::SetEnvironmentVariable("Path", $env:Path, [System.EnvironmentVariableTarget]::Machine)
