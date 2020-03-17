## Create Azure Virtual Network
printInfo "Creating VNET: \"$VNET_NAME\": " $VERBOSE
RESULT=$(az network vnet create \
    --resource-group $RESOURCE_GROUP'' \
    --name $VNET_NAME'' \
    --address-prefixes 10.0.0.0/8 \
    --subnet-name defaultAKS \
    --subnet-prefix 10.240.0.0/16 \
    --query "newVNet.provisioningState")
printInfo "$RESULT\n"

# Get the virtual network resource ID
VNET_ID=$(az network vnet show --resource-group $RESOURCE_GROUP --name $VNET_NAME --subscription $SUBSCRIPTION --query id -o tsv)

# Get the virtual network subnet resource ID
SUBNET_ID=$(az network vnet subnet show --resource-group $RESOURCE_GROUP --vnet-name $VNET_NAME --subscription $SUBSCRIPTION --name defaultAKS --query id -o tsv)