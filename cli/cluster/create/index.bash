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

NETWORK_POLICY="azure"
NETWORK_PLUGIN="azure"
ADDONS="monitoring"
OS_DISK_SIZE=100
LOAD_BALANCER_SKU="Standard"
LOAD_BALANCER_OUTBOUND_IPS=2
CLUSTER_AUTOSCALER=1

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

COMMAND="$COMMAND --name $AKS_NAME --resource-group $RESOURCE_GROUP --location $LOCATION"
COMMAND=" $COMMAND --vnet-subnet-id $SUBNET_ID"
COMMAND=" $COMMAND --service-principal $SP_ID --client-secret $SP_PASSWORD"
COMMAND=" $COMMAND --node-count $MIN_NODES"
COMMAND=" $COMMAND --kubernetes-version $KUBERNETES_VERSION"
COMMAND=" $COMMAND --node-vm-size $VM_SIZE"
COMMAND=" $COMMAND --node-osdisk-size $OS_DISK_SIZE"
COMMAND=" $COMMAND --load-balancer-sku $LOAD_BALANCER_SKU"
COMMAND=" $COMMAND --load-balancer-managed-outbound-ip-count $LOAD_BALANCER_OUTBOUND_IPS"
COMMAND=" $COMMAND --vm-set-type VirtualMachineScaleSets --nodepool-name default"
COMMAND=" $COMMAND --enable-addons $ADDONS"
COMMAND=" $COMMAND --network-policy $NETWORK_POLICY"
COMMAND=" $COMMAND --tags source=kubernetes-snippets"
COMMAND=" $COMMAND --nodepool-tags nodepool=kubernetes-snippets-default"

if [ $CLUSTER_AUTOSCALER == 1 ]
then
    COMMAND=" $COMMAND  --enable-cluster-autoscaler --min-count $MIN_NODES --max-count $MAX_NODES"
fi

if [ "$NETWORK_PLUGIN" = "azure" ]
then
    COMMAND=" $COMMAND --network-plugin azure"
else
    COMMAND=" $COMMAND --network-plugin kubenet --pod-cidr 10.244.0.0/16"
fi

if [ -n "$AAD_SERVER_APPLICATION_ID" -a -n "$AAD_SERVER_APPLICATION_SECRET" -a -n "$AAD_CLIENT_APPLICATION_ID" -a -n "$AAD_TENANT_ID" ]
then    
    printInfo "Adding AAD Configuration...\n" $VERBOSE
    COMMAND=" $COMMAND --aad-server-app-id $AAD_SERVER_APPLICATION_ID --aad-server-app-secret $AAD_SERVER_APPLICATION_SECRET --aad-client-app-id $AAD_CLIENT_APPLICATION_ID --aad-tenant-id $AAD_TENANT_ID"
fi

if [ -n "$NODE_RESOURCE_GROUP" ]
then    
    COMMAND=" $COMMAND --node-resource-group $NODE_RESOURCE_GROUP"
fi


## Additional AKS Stuff
# Kubernetes Virtual IP Configurations
COMMAND=" $COMMAND --service-cidr 10.0.0.0/16 --dns-service-ip 10.0.0.10 --docker-bridge-address 172.17.0.1/16"

# Generate SSH Keys for the cluster VMs
#COMMAND=" $COMMAND --generate-ssh-keys"


printInfo "Creating AKS Cluster \"$AKS_NAME\":" $VERBOSE

$COMMAND

printInfo "Done.\n" $VERBOSE

if [ $LOGIN -a $LOGIN == "admin" ]
then
    printInfo "Getting Credentials as Cluster Admin.\n" $VERBOSE
    az aks get-credentials --resource-group $RESOURCE_GROUP --name $AKS_NAME --admin
elif [ $LOGIN -a $LOGIN == "user" ]
then
    printInfo "Getting Credentials as Cluster User.\n" $VERBOSE
    az aks get-credentials --resource-group $RESOURCE_GROUP --name $AKS_NAME
else
    echo "To connect to your cluster as admin, run az aks get-credentials --resource-group $RESOURCE_GROUP --name $AKS_NAME --admin"
    echo "To connect to your cluster as user, run az aks get-credentials --resource-group $RESOURCE_GROUP --name $AKS_NAME"
fi