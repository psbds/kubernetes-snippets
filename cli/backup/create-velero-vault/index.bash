#/bin/bash
# Authors: Paulo Baima & Vinicius Batista
# Source: https://github.com/psbds/kubernetes-snippets
DIR="${BASH_SOURCE%/*}" ; if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi

source $DIR/_arguments.bash

if [ $LOCATION = "GRS" ]
then
    LOCATION_ARG="--location southcentralus"
    STORAGE_SKU="Standard_GRS"
else
    LOCATION_ARG="--location $LOCATION"
    STORAGE_SKU="Standard_LRS"
fi

# Create the resource group to store the Storage Account
az group create -n $RESOURCE_GROUP $LOCATION_ARG --subscription $SUBSCRIPTION

# Create the Storage Account
az storage account create \
        --subscription $SUBSCRIPTION \
        --name $STORAGE_NAME \
        --resource-group $RESOURCE_GROUP \
        --sku $STORAGE_SKU \
        $LOCATION_ARG \
        --encryption-services blob \
        --https-only true \
        --kind BlobStorage \
        --access-tier Hot

# Create the container inside the storage account to store backups
az storage container create -n $CONTAINER --public-access off --account-name $STORAGE_NAME --subscription $SUBSCRIPTION

echo "SubscriptionId    = '$SUBSCRIPTION'"
echo "Resource Group    = '$RESOURCE_GROUP'"
echo "Storage Account   = '$STORAGE_NAME'"
echo "BLOB Container    = '$CONTAINER'"