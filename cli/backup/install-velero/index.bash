#/bin/bash
# Authors: Paulo Baima & Vinicius Batista
# This Script configures a AKS Cluster to use velero to backup the cluster into the vault created on the 'velero-create-vault.bash' script
# See also: https://github.com/psbds/kubernetes-snippets/blob/master/backup/velero-create-vault.bash
DIR="${BASH_SOURCE%/*}" ; if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi

source $DIR/_arguments.bash

# Create a Service Principal with permissions to the AKS subscription and the subscription where the vault is stored
AZURE_SP_NAME="velero-$(uuidgen | cut -d '-' -f5 | tr '[A-Z]' '[a-z]')"
printInfo "Creating Resource Group Azure AD Service Principal: $AZURE_SP_NAME\n" $VERBOSE
AZURE_TENANT_ID=`az account list --query '[?isDefault].tenantId' -o tsv`
AZURE_CLIENT_SECRET=`az ad sp create-for-rbac --name "$AZURE_SP_NAME" --role "Contributor" --query "password" -o tsv --scopes /subscriptions/$BACKUP_SUBSCRIPTION/resourcegroups/$BACKUP_RESOURCE_GROUP /subscriptions/$CLUSTER_SUBSCRIPTION/resourcegroups/$CLUSTER_RESOURCE_GROUP`
AZURE_CLIENT_ID=`az ad sp list --display-name "$AZURE_SP_NAME" --query '[0].appId' -o tsv`
printInfo "Service Principal $AZURE_SP_NAME($AZURE_CLIENT_ID) created.\n" $VERBOSE

# Create a secrets file with the credentials and parameters to be used in the velero install command
cat << EOF >credentials-velero
AZURE_SUBSCRIPTION_ID=${CLUSTER_SUBSCRIPTION}
AZURE_TENANT_ID=${AZURE_TENANT_ID}
AZURE_CLIENT_ID=${AZURE_CLIENT_ID}
AZURE_CLIENT_SECRET=${AZURE_CLIENT_SECRET}
AZURE_RESOURCE_GROUP=${CLUSTER_RESOURCE_GROUP}
AZURE_CLOUD_NAME=AzurePublicCloud
EOF

# Install Velero Plugin
printInfo "Installing Velero on Cluster.\n" $VERBOSE
velero install \
    --provider azure \
    --plugins velero/velero-plugin-for-microsoft-azure:v1.0.1 \
    --bucket "$BACKUP_CONTAINER" \
    --secret-file ./credentials-velero \
    --backup-location-config resourceGroup=$BACKUP_RESOURCE_GROUP,storageAccount=$BACKUP_STORAGE_ACCOUNT,subscriptionId=$BACKUP_SUBSCRIPTION \
    --snapshot-location-config apiTimeout=5m,resourceGroup=$BACKUP_RESOURCE_GROUP,subscriptionId=$BACKUP_SUBSCRIPTION
printInfo "Velero Installed on Cluster.\n" $VERBOSE

# Remove secrets file
rm credentials-velero
printInfo "Removing Credentials File.\n" $VERBOSE