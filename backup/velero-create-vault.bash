# Authors: Paulo Baima & Vinicius Batista
# This Script creates an Storage Account to serve as vault for velero Backup
# You can check the detailed documentation here: https://github.com/vmware-tanzu/velero-plugin-for-microsoft-azure
set -e

# Parameters

## The Subscription where the Storage Account will be created
AZURE_BACKUP_SUBSCRIPTION_ID=""

## The Resource Group where the Storage Account will be created
AZURE_BACKUP_RESOURCE_GROUP="backup"

## The name of the Container inside of the Blob Storage, where the Backups will be stored
BLOB_CONTAINER="velero-backup"

## The Location where the storage account will store the backups, use GRS for GRS Storage
LOCATION="southcentralus"

## The name of the Storage Account that will be created, you can provide your own name (making sure that is unique, alphanumeric and all lowercase)
## or you can use the command below to generate a new name with an uuid
AZURE_STORAGE_ACCOUNT_ID="velero$(uuidgen | cut -d '-' -f5 | tr '[A-Z]' '[a-z]')"

# Setting the args based whether the storage will be LRS or GRS
if [ $LOCATION = "GRS" ]
then
    LOCATION_ARG="--location southcentralus"
    STORAGE_SKU="Standard_GRS"
else
    LOCATION_ARG="--location $LOCATION"
    STORAGE_SKU="Standard_LRS"
fi

# Create the resource group to store the Storage Account
az group create -n $AZURE_BACKUP_RESOURCE_GROUP $LOCATION_ARG --subscription $AZURE_BACKUP_SUBSCRIPTION_ID

# Create the Storage Account
az storage account create \
        --subscription $AZURE_BACKUP_SUBSCRIPTION_ID \
        --name $AZURE_STORAGE_ACCOUNT_ID \
        --resource-group $AZURE_BACKUP_RESOURCE_GROUP \
        --sku $STORAGE_SKU \
        $LOCATION_ARG \
        --encryption-services blob \
        --https-only true \
        --kind BlobStorage \
        --access-tier Hot

# Create the container inside the storage account to store backups
az storage container create -n $BLOB_CONTAINER --public-access off --account-name $AZURE_STORAGE_ACCOUNT_ID --subscription $AZURE_BACKUP_SUBSCRIPTION_ID

echo "Backup SubscriptionId = '$AZURE_BACKUP_SUBSCRIPTION_ID'"
echo "Backup Resource Group = $AZURE_BACKUP_RESOURCE_GROUP"
echo "Backup Storage Account Id = '$AZURE_STORAGE_ACCOUNT_ID'"
echo "Backup BLOB Container = '$BLOB_CONTAINER'"