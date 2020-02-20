# This Script creates an Storage Account to serve as vault for velero Backup
# You can check the detailed documentation here: https://github.com/vmware-tanzu/velero-plugin-for-microsoft-azure
set -e

# Parameters

## The Resource Group where the Storage Account will be created
AZURE_BACKUP_RESOURCE_GROUP="padasil-aks-backup"

## The Subscription where the Storage Account will be created
AZURE_BACKUP_SUBSCRIPTION_ID=""

## The name of the Container inside of the Blob Storage, where the Backups will be stored
BLOB_CONTAINER="velero-backup"

## The Location where the storage account will store the backups, use GRS for GRS Storage
LOCATION="southcentralus"

az group create -n $AZURE_BACKUP_RESOURCE_GROUP --location southcentralus --subscription $AZURE_BACKUP_SUBSCRIPTION_ID

AZURE_STORAGE_ACCOUNT_ID="velero$(uuidgen | cut -d '-' -f5 | tr '[A-Z]' '[a-z]')"

echo $AZURE_STORAGE_ACCOUNT_ID
if [ $LOCATION = "GRS" ]
then
    az storage account create \
        --subscription $AZURE_BACKUP_SUBSCRIPTION_ID \
        --name $AZURE_STORAGE_ACCOUNT_ID \
        --resource-group $AZURE_BACKUP_RESOURCE_GROUP \
        --sku Standard_GRS \
        --encryption-services blob \
        --https-only true \
        --kind BlobStorage \
        --access-tier Hot
else
    az storage account create \
        --subscription $AZURE_BACKUP_SUBSCRIPTION_ID \
        --name $AZURE_STORAGE_ACCOUNT_ID \
        --resource-group $AZURE_BACKUP_RESOURCE_GROUP \
        --sku Standard_LRS \
        --location $LOCATION \
        --encryption-services blob \
        --https-only true \
        --kind BlobStorage \
        --access-tier Hot
fi

az storage container create -n $BLOB_CONTAINER --public-access off --account-name $AZURE_STORAGE_ACCOUNT_ID

echo "Backup: SubscriptionId='$AZURE_BACKUP_SUBSCRIPTION_ID'"
echo "Backup: Resource Group=$AZURE_BACKUP_RESOURCE_GROUP"
echo "Backup: Storage Account Id='$AZURE_STORAGE_ACCOUNT_ID'"
echo "Backup: BLOB Container='$BLOB_CONTAINER'"