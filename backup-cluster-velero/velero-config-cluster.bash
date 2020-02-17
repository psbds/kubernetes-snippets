set -e

AZURE_BACKUP_SUBSCRIPTION=""
AZURE_BACKUP_RESOURCE_GROUP="padasil-aks-backup"
AZURE_BACKUP_STORAGE_ACCOUNT_ID=""
AZURE_BACKUP_CONTAINER="velero-backup"

AZURE_AKS_SUBSCRIPTION=""
AZURE_AKS_MC_RESOURCE_GROUP="MC_padasil-aks-demo5_padasil-aks-demo5_eastus2"


AZURE_TENANT_ID=`az account list --query '[?isDefault].tenantId' -o tsv`
AZURE_CLIENT_SECRET=`az ad sp create-for-rbac --name "aks-velero" --role "Contributor" --query "password" -o tsv --scopes /subscriptions/$AZURE_AKS_SUBSCRIPTION /subscriptions/$AZURE_BACKUP_SUBSCRIPTION`
AZURE_CLIENT_ID=`az ad sp list --display-name "aks-velero" --query '[0].appId' -o tsv`


cat <<EOF> credentials-velero
AZURE_SUBSCRIPTION_ID=${AZURE_AKS_SUBSCRIPTION}
AZURE_TENANT_ID=${AZURE_TENANT_ID}
AZURE_CLIENT_ID=${AZURE_CLIENT_ID}
AZURE_CLIENT_SECRET=${AZURE_CLIENT_SECRET}
AZURE_RESOURCE_GROUP=${AZURE_AKS_MC_RESOURCE_GROUP}
AZURE_CLOUD_NAME=AzurePublicCloud
EOF


velero install \
    --provider azure \
    --plugins velero/velero-plugin-for-microsoft-azure:v1.0.0 \
    --bucket $AZURE_BACKUP_CONTAINER'' \
    --secret-file ./credentials-velero \
    --backup-location-config resourceGroup=$AZURE_BACKUP_RESOURCE_GROUP,storageAccount=$AZURE_BACKUP_STORAGE_ACCOUNT_ID,subscriptionId=$AZURE_BACKUP_SUBSCRIPTION \
    --snapshot-location-config apiTimeout=5m,resourceGroup=$AZURE_BACKUP_RESOURCE_GROUP,subscriptionId=$AZURE_BACKUP_SUBSCRIPTION