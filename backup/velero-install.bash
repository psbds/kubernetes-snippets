#/bin/bash
# Authors: Paulo Baima & Vinicius Batista
# This Script configures a AKS Cluster to use velero to backup the cluster into the vault created on the 'velero-create-vault.bash' script
# See also: https://github.com/psbds/kubernetes-snippets/blob/master/backup/velero-create-vault.bash
set -e

# Parameters

## The Subscription where the Storage Account for backup was created
AZURE_BACKUP_SUBSCRIPTION=""

## The Resource Group where the Storage Account for backup was created
AZURE_BACKUP_RESOURCE_GROUP=""

## The name of the Storage Account created for backup
AZURE_BACKUP_STORAGE_ACCOUNT_ID=""

## The name of the container created for backup
AZURE_BACKUP_CONTAINER="velero-backup"


## The name of the subcription that the AKS resource is created
AZURE_AKS_SUBSCRIPTION=""

## The name of the resource group where the AKS components are created
## Note: This is not the resource group of the AKS resource itself, it's the resource group where AKS 
##       creates the virtual machines, load balancers, IPs, etc. Its name Usually start with MC_
AZURE_AKS_MC_RESOURCE_GROUP=""


# Create a Service Principal with permissions to the AKS subscription and the subscription where the vault is stored
AZURE_TENANT_ID=`az account list --query '[?isDefault].tenantId' -o tsv`
AZURE_CLIENT_SECRET=`az ad sp create-for-rbac --name "aks-velero" --role "Contributor" --query "password" -o tsv --scopes /subscriptions/$AZURE_AKS_SUBSCRIPTION /subscriptions/$AZURE_BACKUP_SUBSCRIPTION`
AZURE_CLIENT_ID=`az ad sp list --display-name "aks-velero" --query '[0].appId' -o tsv`

# Create a secrets file with the credentials and parameters to be used in the velero install command
cat << EOF >credentials-velero
AZURE_SUBSCRIPTION_ID=${AZURE_AKS_SUBSCRIPTION}
AZURE_TENANT_ID=${AZURE_TENANT_ID}
AZURE_CLIENT_ID=${AZURE_CLIENT_ID}
AZURE_CLIENT_SECRET=${AZURE_CLIENT_SECRET}
AZURE_RESOURCE_GROUP=${AZURE_AKS_MC_RESOURCE_GROUP}
AZURE_CLOUD_NAME=AzurePublicCloud
EOF

# Install Velero Plugin
velero install \
    --provider azure \
    --plugins velero/velero-plugin-for-microsoft-azure:v1.0.1 \
    --bucket "$AZURE_BACKUP_CONTAINER" \
    --secret-file ./credentials-velero \
    --backup-location-config resourceGroup=$AZURE_BACKUP_RESOURCE_GROUP,storageAccount=$AZURE_BACKUP_STORAGE_ACCOUNT_ID,subscriptionId=$AZURE_BACKUP_SUBSCRIPTION \
    --snapshot-location-config apiTimeout=5m,resourceGroup=$AZURE_BACKUP_RESOURCE_GROUP,subscriptionId=$AZURE_BACKUP_SUBSCRIPTION

# Remove secrets file
rm credentials-velero