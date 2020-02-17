## Create Azure Virtual Network
az network vnet create \
    --resource-group $RESOURCE_GROUP_NAME'' \
    --name $VNET_NAME'' \
    --address-prefixes 10.0.0.0/8 \
    --subnet-name defaultAKS \
    --subnet-prefix 10.240.0.0/16

# Get the virtual network resource ID
VNET_ID=$(az network vnet show --resource-group $RESOURCE_GROUP_NAME --name $VNET_NAME --query id -o tsv)

# Get the virtual network subnet resource ID
SUBNET_ID=$(az network vnet subnet show --resource-group $RESOURCE_GROUP_NAME --vnet-name $VNET_NAME --name defaultAKS --query id -o tsv)