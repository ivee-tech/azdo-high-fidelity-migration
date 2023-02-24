$rgName = 'devops-migration-rg'
$location = 'AustraliaEast'

# create RG
az group create --name $rgName --location $location

# create VNet with AzureFirewallSubnet and additonal two subnets
$vnetName = 'devop-migration-vnet'
$vnetAddressPrefix = '10.0.0.0/16'
$workSubnetName = 'workload-subnet'
$workAddressPrefix = '10.0.2.0/24'
$jumpSubnetName = 'jump-subnet'
$jumpAddressPrefix = '10.0.3.0/24'

az network vnet create `
  --name $vnetName `
  --resource-group $rgName `
  --location $location `
  --address-prefix $vnetAddressPrefix `
  --subnet-name AzureFirewallSubnet `
  --subnet-prefix 10.0.1.0/26
az network vnet subnet create `
  --name $workSubnetName `
  --resource-group $rgName `
  --vnet-name $vnetName `
  --address-prefix $workAddressPrefix 
az network vnet subnet create `
  --name $jumpSubnetName `
  --resource-group $rgName `
  --vnet-name $vnetName `
  --address-prefix $jumpAddressPrefix

# create jump VM
$jumpVMName = 'jumpvm'
$jumpImage = 'win2016datacenter'
$jumpAdminUser = 'jump-admin'
$jumpAdminPassword = '***'
az vm create `
    --resource-group $rgName `
    --name $jumpVMName `
    --location $location `
    --image $jumpImage `
    --vnet-name $vnetName `
    --subnet $jumpSubnetName `
    --admin-username $jumpAdminUser `
    --admin-password $jumpAdminPassword
az vm open-port --port 3389 --resource-group $rgName --name $jumpVMName

# create workload VM (SQL VM)
$workVMName = 'sqlvm'
$publisherName = "MicrosoftSqlServer"
$offerName = "SQL2017-WS2016" # "WindowsServer" # "SQL2008R2SP3-WS2008R2SP1" # "SQL2017-WS2016"
$sku = "SQLDEV" # "2016-Datacenter" # "Standard"
$version = "latest"
$workImage = "$($publisherName):$($offerName):$($sku):$($version)"
$nicName = "$($workVMName)-NIC"
$workAdminUser = 'sqlvm-admin'
$workAdminPassword = '***'
# create NIC with no public IP address
az network nic create `
    -g $rgName `
    -n $nicName `
   --vnet-name $vnetName `
   --subnet $workSubnetName `
   --public-ip-address '""' `
   --dns-servers 209.244.0.3 209.244.0.4
az vm create `
   --resource-group $rgName `
   --name $workVMName `
   --location $location `
   --image $workImage `
   --nics $nicName `
   --admin-username $workAdminUser `
   --admin-password $workAdminPassword

# deploy firewall
$pipName = 'devops-migration-pip'
$fwName = 'devops-migration-fw'
$configName = "$fwName-config"
az network firewall create `
    --name $fwName `
    --resource-group $rgName `
    --location $location `
az network public-ip create `
    --name $pipName `
    --resource-group $rgName `
    --location $location `
    --allocation-method static `
    --sku standard
az network firewall ip-config create `
    --firewall-name $fwName `
    --name $configName `
    --public-ip-address $pipName `
    --resource-group $rgName `
    --vnet-name $vnetName `
az network firewall update `
    --name $fwName `
    --resource-group $rgName `
az network public-ip show `
    --name $pipName `
    --resource-group $rgName
$fwPrivateAddress = "$(az network firewall ip-config list -g $rgName -f $fwName --query "[?name=='$($configName)'].privateIpAddress" --output tsv)"


# create route table with BGP route propagation disabled
$routeTableName = "$fwName-rt-table"
az network route-table create `
    --name $routeTableName `
    --resource-group $rgName `
    --location $location `
    --disable-bgp-route-propagation true

# create route
$routeName = 'dg-route'
az network route-table route create `
  --resource-group $rgName `
  --name $routeName `
  --route-table-name $routeTableName `
  --address-prefix 0.0.0.0/0 `
  --next-hop-type VirtualAppliance `
  --next-hop-ip-address $fwPrivateAddress

# associate route table with the subnet
az network vnet subnet update `
    -n $workSubnetName `
    -g $rgName `
    --vnet-name $vnetName `
    --address-prefixes $workAddressPrefix `
    --route-table $routeTableName


# configure application rule (outbound access to Google)
$appCollName = 'app-coll-01'
az network firewall application-rule create `
   --collection-name $appCollName `
   --firewall-name $fwName `
   --name Allow-Google `
   --protocols Http=80 Https=443 `
   --resource-group $rgName `
   --target-fqdns www.google.com `
   --source-addresses $workAddressPrefix `
   --priority 200 `
   --action Allow

# configure network rule (outbound access to two IP addresses on port 53 - DNS)
$netCollName = 'net-coll-01'
az network firewall network-rule create `
   --collection-name $netCollName `
   --destination-addresses 209.244.0.3 209.244.0.4 `
   --destination-ports 53 `
   --firewall-name $fwName `
   --name Allow-DNS `
   --protocols UDP `
   --resource-group $rgName `
   --priority 200 `
   --source-addresses $workAddressPrefix `
   --action Allow

# test Firewall

# list work VM IP (private)
az vm list-ip-addresses `
   -g $rgName `
   -n $workVMName

# connect to jump VM and open remote desktop connection to work VM (SQL VM)
# run nslookup on worm VM
nslookup www.google.com
nslookup www.microsoft.com

# execute web requests:
# - google.com should work
# - microsoft.com should fail
Invoke-WebRequest -Uri https://www.google.com

Invoke-WebRequest -Uri https://www.microsoft.com


