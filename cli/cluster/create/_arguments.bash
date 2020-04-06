#/bin/bash
# Author: Paulo Baima
# Source: https://github.com/psbds/kubernetes-snippets

# Default Args
{
    VERBOSE=0
    MIN_NODES=1
    MAX_NODES=1
    LOCATION="eastus2"
    KUBERNETES_VERSION="1.16.7"
    VM_SIZE="Standard_DS2_v2"
    LOGIN=""
    SUBSCRIPTION="$(az account show --query id -o tsv)"
   
    # Fixed Arguments
    NETWORK_POLICY="azure"
    NETWORK_PLUGIN="azure"
    ADDONS="monitoring"
    OS_DISK_SIZE=100
    LOAD_BALANCER_SKU="Standard"
    LOAD_BALANCER_OUTBOUND_IPS=2
    CLUSTER_AUTOSCALER=1
}

arguments=( 
    "-n|--name:AKS_NAME"
    "-g|--resource-group:RESOURCE_GROUP"
    "-s|--subscription:SUBSCRIPTION"
    "-l|--location:LOCATION"
    "-min|--min-nodes:MIN_NODES"
    "-max|--max-nodes:MAX_NODES"
    "-vm|--vm-size:VM_SIZE"
    "-k|--kubernetes-version:KUBERNETES_VERSION"
    "-ng|--node-resource-group:NODE_RESOURCE_GROUP"
    "-asai|--aad-server-app-id:AAD_SERVER_APPLICATION_ID"
    "-asas|--aad-server-app-secret:AAD_SERVER_APPLICATION_SECRET"
    "-acai|--aad-client-app-id:AAD_CLIENT_APPLICATION_ID"
    "-ati|--aad-tenant-id:AAD_TENANT_ID"
    "-vnet:CUSTOM_VNET"
    "-vnet-rg:CUSTOM_VNET_RG"
    "-subnet:CUSTOM_SUBNET"
    "-svc-cidr:CUSTOM_SVC_CIDR"
    "-svc-dns-ip:CUSTOM_SVC_DNS_IP"
    "--login:LOGIN"
    "-h|--help:create"
    "-v|--verbose" )

# Source: cli/helpers.bash
read_args arguments $@

validate_args(){
    VALID=1
    validate_empty "$AKS_NAME"              "Argument -n, --name is required.\n"
    validate_empty "$RESOURCE_GROUP"        "Argument -g, --resource-group is required.\n"

    if [ -n "$CUSTOM_VNET" -o -n "$CUSTOM_VNET_RG" -o -n "$CUSTOM_SUBNET" ]
    then
        validate_empty "$CUSTOM_VNET"              "Argument -vnet is required for a pre-created vnet.\n"
        validate_empty "$CUSTOM_VNET_RG"           "Argument -vnet-rg is required for a pre-created vnet.\n"
        validate_empty "$CUSTOM_SUBNET"            "Argument -subnet is required for a pre-created vnet.\n"
        validate_empty "$CUSTOM_SVC_CIDR"          "Argument -svc-cidr is required for a pre-created vnet.\n"
        validate_empty "$CUSTOM_SVC_DNS_IP"        "Argument -svc-dns-ip is required for a pre-created vnet.\n"
    fi

    if [ $LOGIN ]
    then
        validate_options "Argument --login \"$LOGIN\" is invalid.\n" $LOGIN "user" "admin"
    fi

    if [ $VALID == 0 ]; then exit 1; fi
}

validate_args