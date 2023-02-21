## Global
$location = "AustraliaEast"
$rgName = "devops9867"

##Compute
$VMName = "sqlvm"
$VMSize = "Standard_DS13_v2" # "Standard_D2s_v3" # "Standard_DS13_v2"

## Network
$nicName = $rgName + "ServerInterface9867"
$nsgName = $rgName + "nsg9867"
$VNetName = $rgName + "VNet9867" # 'tfs-vnet' # $rgName + "VNet99"
$SubnetName = 'default'
$VNetAddressPrefix = "10.0.0.0/16"
$VNetSubnetAddressPrefix = "10.0.0.0/24"
$TCPIPAllocationMethod = "Dynamic"
$pipName = "pip$($nicName)$(Get-Random)"
$DomainName = 'devops9867-sqlvm'

$VNetAddressPrefix = "10.0.0.0/16"
$VNetSubnetAddressPrefix = "10.0.0.0/24"

##Image
$PublisherName = "MicrosoftSqlServer"
$OfferName = "SQL2017-WS2016" # "WindowsServer" # "SQL2008R2SP3-WS2008R2SP1" # "SQL2017-WS2016"
$Sku = "SQLDEV" # "2016-Datacenter" # "Standard"
$Version = "latest"

$rg = Get-AzResourceGroup -Name $rgName -ErrorAction SilentlyContinue

if(!$rg) {
    New-AzResourceGroup -Name $rgName -Location $location
}
# Create a subnet configuration
$subnetConfig = New-AzVirtualNetworkSubnetConfig -Name $SubnetName -AddressPrefix $VNetSubnetAddressPrefix

# Create a virtual network
$vnet = New-AzVirtualNetwork -ResourceGroupName $rgName -Location $location `
    -Name $VNetName -AddressPrefix $VNetAddressPrefix -Subnet $subnetConfig

# $vnet = Get-AzVirtualNetwork -Name $VNetName -ResourceGroupName $rgName

# Create a public IP address and specify a DNS name
$pip = New-AzPublicIpAddress -ResourceGroupName $rgName -Location $location `
    -AllocationMethod $TCPIPAllocationMethod -IdleTimeoutInMinutes 4 -Name $pipName `
    -DomainNameLabel $DomainName

# Create an inbound network security group rule for port 3389
$nsgRuleRDP = New-AzNetworkSecurityRuleConfig -Name RDPRule -Protocol Tcp `
    -Direction Inbound -Priority 1000 -SourceAddressPrefix * -SourcePortRange * -DestinationAddressPrefix * `
    -DestinationPortRange 3389 -Access Allow

# Create a SQL Rule # this will open 1433 to any source, not recommended; use instead the Azure DevOps IPs
<#
$nsgRuleSQL = New-AzureRmNetworkSecurityRuleConfig -Name "MSSQLRule"  -Protocol Tcp -Direction Inbound -Priority 1001 `
    -SourceAddressPrefix * -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 1433 -Access Allow
#>

# Create a network security group
$nsg = New-AzNetworkSecurityGroup -ResourceGroupName $rgName -Location $location `
    -Name $nsgName -SecurityRules $nsgRuleRDP #,$nsgRuleSQL

# Create a virtual network card and associate with public IP address and NSG
$nic = New-AzNetworkInterface -Name $nicName -ResourceGroupName $rgName -Location $location `
    -SubnetId $vnet.Subnets[0].Id -PublicIpAddressId $pip.Id -NetworkSecurityGroupId $nsg.Id

# Define a credential object
$cred = Get-Credential -Message "Type the name and password of the local administrator account."

# Create a virtual machine configuration
$vmConfig = New-AzVMConfig -VMName $VMName -VMSize $VMSize | `
    Set-AzVMOperatingSystem -Windows -ComputerName $VMName -Credential $cred | `
    Set-AzVMSourceImage -PublisherName $PublisherName -Offer $OfferName `
    -Skus $Sku -Version $Version | Add-AzVMNetworkInterface -Id $nic.Id

# Create the virtual machine
New-AzVM -ResourceGroupName $rgName -Location $location -VM $vmConfig
