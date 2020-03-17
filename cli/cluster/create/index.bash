#/bin/bash
# Author: Paulo Baima
# This Script creates a AKS Cluster with the defined parameters
# Fist, run 'az login' to login into your account
set -e

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi

source "$DIR/_arguments.bash" 

# Parameters

## The Name of the VNET that will be created
VNET_NAME=$AKS_NAME"-vnet"

## Kubernetes Version
KUBERNETES_VERSION="1.16.4"

## VM Size & Type
VM_SIZE="Standard_DS2_v2"

## Custom Name for the Resource Group created to store aks resources (vmss, load balancers, ips, etc.)
CUSTOM_RESOURCE_GROUP=""


## The Credentials for integration with Azure Active Directory
## See: https://github.com/psbds/kubernetes-snippets/tree/master/kubernetes-permissions

# Choose a Network Plugin: https://docs.microsoft.com/en-us/azure/aks/concepts-network#azure-virtual-networks
# Azure CNI: https://docs.microsoft.com/en-us/azure/aks/configure-azure-cni
# Kubenet: https://docs.microsoft.com/en-us/azure/aks/configure-kubenet
NETWORK_PLUGIN="azure" # or kubenet

# End of Parameters

## Create Azure Resource Group
printInfo "Creating Resource Group \"$RESOURCE_GROUP\": " $VERBOSE
RESULT=$(az group create --name $RESOURCE_GROUP --location $LOCATION --subscription $SUBSCRIPTION --query "properties.provisioningState")
printInfo "$RESULT\n" $VERBOSE

## Create the Virtual Network
# In: $SUBSCRIPTION_ID
# In: $RESOURCE_GROUP_NAME
# In: $VNET_NAME
# Out: $VNET_ID
# Out: $SUBNET_ID
source "$DIR/create-vnet.bash"

## Create Service Principal to Manage Cluster Resources
# In: $SUBSCRIPTION_ID
# In: $VNET_ID 
# Out: SP_ID
# Out: SP_PASSWORD
source "$DIR/create-service-principal.bash"


## Lets Create 'az aks create' command
COMMAND="az aks create"

# Resource Group, Resource Name and Location, Common Azure Stuff
COMMAND="$COMMAND --name $AKS_NAME --resource-group $RESOURCE_GROUP --location $LOCATION"

# Set Custom Resource Group for AKS Resources
if [ -n "$CUSTOM_RESOURCE_GROUP" ]
then    
    COMMAND=" $COMMAND --node-resource-group $CUSTOM_RESOURCE_GROUP"
fi

# Set the Subnet the cluter will be placed
COMMAND=" $COMMAND --vnet-subnet-id $SUBNET_ID"

# Set the Service Principal AKS will use to create and manage Azure resources
COMMAND=" $COMMAND --service-principal $SP_ID --client-secret $SP_PASSWORD"

# Set the number of nodes the cluster will start with
COMMAND=" $COMMAND --node-count $MIN_NODES"

# Set Kubernetes Version
COMMAND=" $COMMAND --kubernetes-version $KUBERNETES_VERSION"

# Set VM Size
COMMAND=" $COMMAND --node-vm-size $VM_SIZE"

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
if [ "$NETWORK_PLUGIN" = "azure" ]
then
    COMMAND=" $COMMAND --network-plugin azure"
else
    COMMAND=" $COMMAND --network-plugin kubenet --pod-cidr 10.244.0.0/16"
fi

# Lets configure the Azure AD Integration
if [ -n "$AAD_SERVER_APPLICATION_ID" -a -n "$AAD_SERVER_APPLICATION_SECRET" -a -n "$AAD_CLIENT_APPLICATION_ID" -a -n "$AAD_TENANT_ID" ]
then    
    printInfo "Adding AAD Configuration...\n" $VERBOSE
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
COMMAND=" $COMMAND --nodepool-tags nodepool=kubernetes-snippets-default"

printInfo "Creating AKS Cluster \"$AKS_NAME\":" $VERBOSE

$COMMAND

printInfo "Done.\n" $VERBOSE

if [ -n $LOGIN -a $LOGIN == "admin" ]
then
    printInfo "Getting Credentials as Cluster Admin.\n" $VERBOSE
    az aks get-credentials --resource-group $RESOURCE_GROUP --name $AKS_NAME --admin
elif [ -n $LOGIN -a $LOGIN == "user" ]
then
    printInfo "Getting Credentials as Cluster User.\n" $VERBOSE
    az aks get-credentials --resource-group $RESOURCE_GROUP --name $AKS_NAME
else
    echo "To connect to your cluster as admin, run az aks get-credentials --resource-group $RESOURCE_GROUP --name $AKS_NAME --admin"
    echo "To connect to your cluster as user, run az aks get-credentials --resource-group $RESOURCE_GROUP --name $AKS_NAME"
fi
