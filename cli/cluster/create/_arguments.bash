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
    validate_empty "$SUBSCRIPTION"          "Argument -s, --subscription is required.\n"

    if [ $VALID == 0 ]
    then
        exit 1;
    fi    
}

validate_args