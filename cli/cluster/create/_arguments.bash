#/bin/bash
# Author: Paulo Baima
# Source: https://github.com/psbds/kubernetes-snippets
set -e

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi

source $DIR/_help.bash


# Default Args
VERBOSE=0
MIN_NODES=1
MAX_NODES=1
LOCATION="eastus2"
KUBERNETES_VERSION="1.16.7"
VM_SIZE="Standard_DS2_v2"
LOGIN=""
while [ "$1" != "" ]; do
    case $1 in
        -n | --name )                       shift && AKS_NAME=$1
                                            ;;
        -g | --resource-group )             shift && RESOURCE_GROUP=$1
                                            ;;
        -s | --subscription )               shift && SUBSCRIPTION=$1
                                            ;;
        -l | --location )                   shift && LOCATION=$1
                                            ;;
        -min | --min-nodes )                shift && MIN_NODES=$1
                                            ;;
        -max | --max-nodes )                shift && MAX_NODES=$1
                                            ;;
        -vm | --vm-size )                   shift && VM_SIZE=$1
                                            ;;
        -k | --kubernetes-version )         shift && KUBERNETES_VERSION=$1
                                            ;;
        -ng | --node-resource-group )       shift && NODE_RESOURCE_GROUP=$1
                                            ;;
        -asai | --aad-server-app-id )       shift && AAD_SERVER_APPLICATION_ID=$1
                                            ;;
        -asas | --aad-server-app-secret )   shift && AAD_SERVER_APPLICATION_SECRET=$1
                                            ;;
        -acai | --aad-client-app-id )       shift && AAD_CLIENT_APPLICATION_ID=$1
                                            ;;
        -ati | --aad-tenant-id )            shift && AAD_TENANT_ID=$1
                                            ;;
        -vnet  )                            shift && CUSTOM_VNET=$1
                                            ;;
        -vnet-rg  )                         shift && CUSTOM_VNET_RG=$1
                                            ;;
        -subnet  )                          shift && CUSTOM_SUBNET=$1
                                            ;;
        --login )                           shift && LOGIN=$1
                                            ;;
        -h | --help )                       usage && exit
                                            ;;
        -v | --verbose )                    VERBOSE=1
                                            ;;
    esac
    shift
done


validate_args(){
    VALID=1
    validate_empty "$AKS_NAME"              "Argument -n, --name is required.\n"
    validate_empty "$RESOURCE_GROUP"        "Argument -g, --resource-group is required.\n"

    if [ -n "$CUSTOM_VNET" -o -n "$CUSTOM_VNET_RG" -o -n "$CUSTOM_SUBNET" ]
    then
        validate_empty "$CUSTOM_VNET"              "Argument -vnet is required for a pre-created vnet.\n"
        validate_empty "$CUSTOM_VNET_RG"           "Argument -vnet-rg is required for a pre-created vnet.\n"
        validate_empty "$CUSTOM_SUBNET"            "Argument -subnet is required for a pre-created vnet.\n"

    fi

    if [ $LOGIN ]
    then
        validate_options "Argument --login \"$LOGIN\" is invalid.\n" $LOGIN "user" "admin"
    fi

    if [ $VALID == 0 ]
    then
        exit 1;
    fi    
}

validate_args