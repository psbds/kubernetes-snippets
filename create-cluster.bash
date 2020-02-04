set -e

# Fist, run 'az login' to login into your account
# Then, use 'az account set --subscription <<Subscription>>' to select your subscription
RESOURCE_GROUP_NAME="padasil-aks-demo2"
AKS_NAME="padasil-aks-demo2"
VNET_NAME="padasil-aks-vnet-demo2"
LOCATION="eastus2"

AAD_SERVER_APPLICATION_ID=""
AAD_SERVER_APPLICATION_SECRET=""
AAD_CLIENT_APPLICATION_ID=""
AAD_TENANT_ID=""

# Choose a Network Plugin: https://docs.microsoft.com/en-us/azure/aks/concepts-network#azure-virtual-networks
# Azure CNI: https://docs.microsoft.com/en-us/azure/aks/configure-azure-cni
# Kubenet: https://docs.microsoft.com/en-us/azure/aks/configure-kubenet
NETWORK_PLUGIN="azure" # or kubenet


## Create Azure Resource Group
az group create --name $RESOURCE_GROUP_NAME --location $LOCATION

## Create the Virtual Network
# In: $RESOURCE_GROUP_NAME
# In: $VNET_NAME
# Out: $VNET_ID
# Out: $SUBNET_ID
source create-vnet.bash

## Create Service Principal to Manage Cluster Resources
# In: $VNET_ID 
# Out: SP_ID
# Out: SP_PASSWORD
source create-service-principal.bash

# Assign the service principal Contributor permissions to the virtual network resource
az role assignment create --assignee $SP_ID --scope $VNET_ID --role Contributor


# Evaluating Network Plugin
if [ $NETWORK_PLUGIN -eq "azure" ]
then
    NETWORK_PLUGIN="--network-plugin azure"
else
    NETWORK_PLUGIN="--network-plugin kubenet --pod-cidr 10.244.0.0/16"
fi

# Evaluating AAD Integration
if [ -z $AAD_SERVER_APPLICATION_ID -a -z $AAD_SERVER_APPLICATION_SECRET -a -z $AAD_CLIENT_APPLICATION_ID -a -z $AAD_TENANT_ID]
    AAD_INTEGRATION="--aad-server-app-id $serverApplicationId --aad-server-app-secret $serverApplicationSecret --aad-client-app-id $clientApplicationId --aad-tenant-id $tenantId"
else
    AAD_INTEGRATION=""
fi



az aks create \
    \ # Resource Group and Resource Name, Common Azure Stuff
    --resource-group $RESOURCE_GROUP_NAME \
    --name $AKS_NAME \
    \ # Number of Nodes that will be created together with the AKS resource and Generate SSH public and private key files if missing.
    --node-count 1 \
    --generate-ssh-keys \
    \ # Network Plugin
    $NETWORK_PLUGIN \ 
    \ # Azure Active Directory Integration
    $AAD_INTEGRATION \
    \ # Kubernetes internal IP Configurations
    --service-cidr 10.0.0.0/16 \
    --dns-service-ip 10.0.0.10 \
    --docker-bridge-address 172.17.0.1/16 \
    \ # VNET Configuration
    --vnet-subnet-id $SUBNET_ID \
    \ # Attaching Service Principal
    --service-principal $SP_ID \
    --client-secret $SP_PASSWORD \
    \ # Configuring Network Policies: https://docs.microsoft.com/en-us/azure/aks/use-network-policies
    --network-policy azure \
    \ # Configuring Use of VMSS(Node Pools): https://docs.microsoft.com/en-us/azure/aks/use-multiple-node-pools
    --vm-set-type VirtualMachineScaleSets \
    --enable-cluster-autoscaler \
    --min-count 1 \
    --max-count 3

az aks get-credentials --resource-group $RESOURCE_GROUP_NAME --name $AKS_NAME