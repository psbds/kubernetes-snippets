set -e

# Fist, run 'az login' to login into your account
# Then, use 'az account set --subscription <<Subscription>>' to select your subscription
RESOURCE_GROUP_NAME="padasil-aks-demo5"
AKS_NAME="padasil-aks-demo5"
VNET_NAME="padasil-aks-vnet-demo5"
LOCATION="eastus2"

MIN_NODES=1
MAX_NODES=2

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
source ./create-vnet.bash

## Create Service Principal to Manage Cluster Resources
# In: $VNET_ID 
# Out: SP_ID
# Out: SP_PASSWORD
source ./create-service-principal.bash

# Assign the service principal Contributor permissions to the virtual network resource
az role assignment create --assignee $SP_ID --scope $VNET_ID --role Contributor

## Lets Create 'az aks create' command
COMMAND="az aks create"

# Resource Group, Resource Name and Location, Common Azure Stuff
COMMAND="$COMMAND --name $AKS_NAME --resource-group $RESOURCE_GROUP_NAME --location $LOCATION"

# Set the Subnet the cluter will be placed
COMMAND=" $COMMAND --vnet-subnet-id $SUBNET_ID"

# Set the Service Principal AKS will use to create and manage Azure resources
COMMAND=" $COMMAND --service-principal $SP_ID --client-secret $SP_PASSWORD"

# Set the number of nodes the cluster will start with
COMMAND=" $COMMAND --node-count 1"

# Set Kubernetes Version
COMMAND=" $COMMAND --kubernetes-version 1.16.4"

# Set VM Size
COMMAND=" $COMMAND --node-vm-size Standard_DS2_v2"

# Set OS Disk Size, please check if your VM can handle the required IOPS
COMMAND=" $COMMAND --node-osdisk-size 100"

# Set Load Balancer Type
# SKU Comparison: https://docs.microsoft.com/pt-br/azure/load-balancer/concepts-limitations#skus
# For production workloads, is recommended to use Standard SKU, but please check the pricing 
COMMAND=" $COMMAND --load-balancer-sku Standard"

# Set the number of Outbound IPs for a Cluster with Standard Load Balancer
# !Important: Depending on your applications, you can have SNAT exhaustion, increasing the number of outbound IPs should give you need ports to outbound
# Please Review: https://docs.microsoft.com/en-us/azure/load-balancer/load-balancer-outbound-connections#snatexhaust
COMMAND=" $COMMAND --load-balancer-managed-outbound-ip-count 2"

# Configuring Use of VMSS(Node Pools): https://docs.microsoft.com/en-us/azure/aks/use-multiple-node-pools
COMMAND=" $COMMAND --vm-set-type VirtualMachineScaleSets --nodepool-name default"

# Enable Cluster Auto-Scaler: https://docs.microsoft.com/en-us/azure/aks/cluster-autoscaler
COMMAND=" $COMMAND  --enable-cluster-autoscaler --min-count $MIN_NODES --max-count $MAX_NODES"

# Lets Enable Container Insights Monitoring: https://docs.microsoft.com/en-us/azure/azure-monitor/insights/container-insights-overview
COMMAND=" $COMMAND --enable-addons monitoring"

# Lets set the Network Plugin
if [ $NETWORK_PLUGIN = "azure" ]
then
    COMMAND=" $COMMAND --network-plugin azure"
else
    COMMAND=" $COMMAND --network-plugin kubenet --pod-cidr 10.244.0.0/16"
fi

# Lets configure the Azure AD Integration
if [ -n $AAD_SERVER_APPLICATION_ID -a -n $AAD_SERVER_APPLICATION_SECRET -a -n $AAD_CLIENT_APPLICATION_ID -a -n $AAD_TENANT_ID ]
then    
    COMMAND=" $COMMAND --aad-server-app-id $AAD_SERVER_APPLICATION_ID --aad-server-app-secret $AAD_SERVER_APPLICATION_SECRET --aad-client-app-id $AAD_CLIENT_APPLICATION_ID --aad-tenant-id $AAD_TENANT_ID"
fi

# Configure Network Policy: https://docs.microsoft.com/en-us/azure/aks/use-network-policies
COMMAND=" $COMMAND --network-policy azure"

## Additional AKS Stuff
# Kubernetes Virtual IP Configurations
COMMAND=" $COMMAND --service-cidr 10.0.0.0/16 --dns-service-ip 10.0.0.10 --docker-bridge-address 172.17.0.1/16"

# Generate SSH Keys for the cluster VMs
COMMAND=" $COMMAND --generate-ssh-keys"

# Add any Tag you want
COMMAND=" $COMMAND --tags source=kubernetes-snippets"


$COMMAND

echo "To connect to your cluster as admin, run az aks get-credentials --resource-group $RESOURCE_GROUP_NAME --name $AKS_NAME --admin"
echo "To connect to your cluster as user, run az aks get-credentials --resource-group $RESOURCE_GROUP_NAME --name $AKS_NAME"