## Global
$location = "AustraliaEast"
$rgName = "devops-migration-rg"

##Compute
$vmName = "sqlvm"
$vmSize = "Standard_D8s_v5" # "Standard_D2s_v3" # "Standard_DS13_v2"

## Network
$nicName = $rgName + "ServerInterface9867"
$nsgName = $rgName + "nsg9867"
$vnetName = $rgName + "VNet9867" # 'tfs-vnet' # $rgName + "VNet99"
$subnetName = 'default'
$vnetAddressPrefix = "10.0.0.0/16"
$subnetAddressPrefix = "10.0.0.0/24"
$allocationMethod = "Dynamic"
$pipName = "pip$($nicName)$(Get-Random)"
$domainName = 'devops-migration-sqlvm'

$vnetAddressPrefix = "10.0.0.0/16"
$subnetAddressPrefix = "10.0.0.0/24"

##Image
$publisherName = "MicrosoftSqlServer"
$offerName = "SQL2017-WS2016" # "WindowsServer" # "SQL2008R2SP3-WS2008R2SP1" # "SQL2017-WS2016"
$sku = "SQLDEV" # "2016-Datacenter" # "Standard"
$version = "latest"

# ensure you are logged in to the correct Azure subscription
# az login
# az account show
# az account set --subscription <sub>
# get the VM sizes for a specific location 
az vm list-sizes -l $location > C:\Data\vm-list-sizes.json

# $rgName = Get-AzResourceGroup -Name $rgName -ErrorAction SilentlyContinue
$rgName = $(az group show -n $rgName) | ConvertFrom-Json

if(!$rgName) {
    # New-AzResourceGroup -Name $rgName -Location $location
    az group create -n $rgName --location $location
}
# Create a subnet configuration
# $subnetConfig = New-AzVirtualNetworkSubnetConfig -Name $subnetName -AddressPrefix $subnetAddressPrefix

# Create a virtual network
# $vnet = New-AzVirtualNetwork -ResourceGroupName $rgName -Location $location `
#    -Name $vnetName -AddressPrefix $vnetAddressPrefix -Subnet $subnetConfig

az network vnet create `
  --name $vnetName `
  --resource-group $rgName `
  --address-prefixes $vnetAddressPrefix `
  --subnet-name $subnetName `
  --subnet-prefixes $subnetAddressPrefix
# $vnet = Get-AzVirtualNetwork -Name $VNetName -ResourceGroupName $rgName

# Create a public IP address and specify a DNS name
# $pip = New-AzPublicIpAddress -ResourceGroupName $rgName -Location $location `
#     -AllocationMethod $allocationMethod -IdleTimeoutInMinutes 4 -Name $pipName `
#     -DomainNameLabel $domainName

az network public-ip create -g $rgName -n $pipName --dns-name $domainName --allocation-method $allocationMethod

# Create an inbound network security group rule for port 3389
# $nsgRuleRDP = New-AzNetworkSecurityRuleConfig -Name RDPRule -Protocol Tcp `
#     -Direction Inbound -Priority 1000 -SourceAddressPrefix * -SourcePortRange * -DestinationAddressPrefix * `
#     -DestinationPortRange 3389 -Access Allow

# Create a SQL Rule # this will open 1433 to any source, not recommended; use instead the Azure DevOps IPs
<#
$nsgRuleSQL = New-AzureRmNetworkSecurityRuleConfig -Name "MSSQLRule"  -Protocol Tcp -Direction Inbound -Priority 1001 `
    -SourceAddressPrefix * -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 1433 -Access Allow
#>

# Create a network security group
# $nsg = New-AzNetworkSecurityGroup -ResourceGroupName $rgName -Location $location `
#     -Name $nsgName -SecurityRules $nsgRuleRDP #,$nsgRuleSQL
az network nsg create --name $nsgName `
    --resource-group $rgName

az network nsg rule create --name RDPRule `
    --nsg-name $nsgName `
    --resource-group $rgName `
    --access Allow --direction Inbound --priority 1000 `
    --source-address-prefixes * --source-port-ranges * `
    --destination-address-prefixes * --destination-port-ranges 3389

# Create a virtual network card and associate with public IP address and NSG
# $nic = New-AzNetworkInterface -Name $nicName -ResourceGroupName $rgName -Location $location `
#     -SubnetId $vnet.Subnets[0].Id -PublicIpAddressId $pip.Id -NetworkSecurityGroupId $nsg.Id
az network nic create -g $rgName --vnet-name $vnetName --subnet $subnetName -n $nicName `
    --network-security-group $nsgName --public-ip-address $pipName

# Define a credential object
# $cred = Get-Credential -Message "Type the name and password of the local administrator account."

# Create a virtual machine configuration
# $vmConfig = New-AzVMConfig -VMName $vmName -VMSize $vmSize | `
#     Set-AzVMOperatingSystem -Windows -ComputerName $vmName -Credential $cred | `
#     Set-AzVMSourceImage -PublisherName $PublisherName -Offer $OfferName `
#     -Skus $Sku -Version $Version | Add-AzVMNetworkInterface -Id $nic.Id

# Create the virtual machine
# New-AzVM -ResourceGroupName $rgName -Location $location -VM $vmConfig
$adminUserName = 'sqlvm-admin'
$adminPassword = '***'
az vm create `
  --resource-group $rgName `
  --name $vmName `
  --size $vmSize `
  --image "$($publisherName):$($offerName):$($sku):$($version)" `
  --nics $nicName `
  --admin-username $adminUserName --admin-password $adminPassword
