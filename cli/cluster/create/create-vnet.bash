## Create Azure Virtual Network

if [ -z "$CUSTOM_VNET" ]
then
printInfo "Creating VNET: \"$VNET_NAME\": " $VERBOSE
RESULT=$(az network vnet create \
    --resource-group $RESOURCE_GROUP'' \
    --name $VNET_NAME'' \
    --address-prefixes 10.0.0.0/8 \
    --subnet-name defaultAKS \
    --subnet-prefix 10.240.0.0/16 \
    --query "newVNet.provisioningState")
printInfo "$RESULT\n"

CUSTOM_SVC_CIDR="10.0.0.0/16"
CUSTOM_SVC_DNS_IP="10.0.0.10"
VNET_ID=$(az network vnet show --resource-group $RESOURCE_GROUP --name $VNET_NAME --subscription $SUBSCRIPTION --query id -o tsv)
SUBNET_ID=$(az network vnet subnet show --resource-group $RESOURCE_GROUP --vnet-name $VNET_NAME --subscription $SUBSCRIPTION --name defaultAKS --query id -o tsv)
else
VNET_ID=$(az network vnet show --resource-group $CUSTOM_VNET_RG --name $CUSTOM_VNET --subscription $SUBSCRIPTION --query id -o tsv)
SUBNET_ID=$(az network vnet subnet show --resource-group $CUSTOM_VNET_RG --vnet-name $CUSTOM_VNET --subscription $SUBSCRIPTION --name $CUSTOM_SUBNET --query id -o tsv)
fi

