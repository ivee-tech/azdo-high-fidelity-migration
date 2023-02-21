$rgName = 'devops9867'
$nsgName = $rgName + 'nsg9867'
$destPort = 1433

$items = @(
    @{
        serviceName = 'Azure DevOps Services Identity Service 1'; 
        IPs = '168.62.105.45';
    },
    @{
        serviceName = 'Azure DevOps Services Identity Service 2'; 
        IPs = '40.81.42.115';
    },
    @{
        serviceName = 'Regional Identity Service - Australia East 1'; 
        IPs = '13.75.145.145';
    },
    @{
        serviceName = 'Regional Identity Service - Australia East 2'; 
        IPs = '40.82.217.103';
    },
    @{
        serviceName = 'Regional Identity Service - Australia East 3'; 
        IPs = '20.188.213.113';
    },
    @{
        serviceName = 'Regional Identity Service - Australia East 4'; 
        IPs = '104.210.88.194';
    },
    @{
        serviceName = 'Regional Identity Service - Australia East 5'; 
        IPs = '40.81.62.114';
    },
    @{
        serviceName = 'Regional Identity Service - Australia East 6'; 
        IPs = '20.37.194.0/24';
    },
    @{
        serviceName = 'Data Migration tool - Australia East 1'; 
        IPs = '13.75.134.204';
    },
    @{
        serviceName = 'Data Migration tool - Australia East 2'; 
        IPs = '40.82.219.41';
    },
    @{
        serviceName = 'Data Migration tool - Australia East 3'; 
        IPs = '20.40.124.19';
    },
    @{
        serviceName = 'Azure DevOps Services - Australia East 1'; 
        IPs = '13.75.145.145';
    },
    @{
        serviceName = 'Azure DevOps Services - Australia East 2'; 
        IPs = '40.82.217.103';
    },
    @{
        serviceName = 'Azure DevOps Services - Australia East 3'; 
        IPs = '20.188.213.113';
    },
    @{
        serviceName = 'Azure DevOps Services - Australia East 4'; 
        IPs = '104.210.88.194';
    },
    @{
        serviceName = 'Azure DevOps Services - Australia East 5'; 
        IPs = '40.81.62.114';
    },
    @{
        serviceName = 'Releases service - Australia East 1'; 
        IPs = '13.73.204.151';
    },
    @{
        serviceName = 'Releases service - Australia East 2'; 
        IPs = '20.40.176.135';
    },
    @{
        serviceName = 'Azure Artifacts - Australia East 1'; 
        IPs = '13.73.100.166';
    },
    @{
        serviceName = 'Azure Artifacts - Australia East 2'; 
        IPs = '20.40.176.15';
    },
    @{
        serviceName = 'Azure Artifacts - Australia East 3'; 
        IPs = '40.81.59.69';
    },
    @{
        serviceName = 'Azure Artifacts Feed - Australia East 1'; 
        IPs = '13.70.143.138';
    },
    @{
        serviceName = 'Azure Artifacts Feed - Australia East 2'; 
        IPs = '20.40.176.80';
    },
    @{
        serviceName = 'Azure Artifacts Blob - Australia East 1'; 
        IPs = '40.127.86.30';
    },
    @{
        serviceName = 'Azure Artifacts Blob - Australia East 2'; 
        IPs = '20.188.213.113';
    },
    @{
        serviceName = 'Azure Artifacts Blob - Australia East 3'; 
        IPs = '40.82.221.14';
    },
    @{
        serviceName = 'Test Plans - Australia East 1'; 
        IPs = '20.40.177.101';
    },
    @{
        serviceName = 'Analytics service - Australia East 1'; 
        IPs = '20.40.179.159';
    }
    )

$items | % { $index = 0 } {
    $serviceName = $_.serviceName
    $ruleName = $_.serviceName.Replace(' ', '') #.Substring(0, 80)
    $priority = 2000 + $index
    $IPs = $_.IPs
    $description = 'Allow ' + $_.serviceName
    # Write-Output $ruleName, $ruleName.Length, $priority

    <#
    $nsg = Get-AzNetworkSecurityGroup -Name  $nsgName -ResourceGroupName $rgName
    Remove-AzNetworkSecurityRuleConfig -Name $ruleName -NetworkSecurityGroup $nsg
    #>

    Get-AzNetworkSecurityGroup -Name  $nsgName -ResourceGroupName $rgName | 
    Add-AzNetworkSecurityRuleConfig -Name $ruleName -Access Allow -Protocol Tcp `
        -Direction Inbound -Priority $priority -SourceAddressPrefix $IPs -Description $description `
        -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange $destPort | 
    Set-AzNetworkSecurityGroup

    $index++
}