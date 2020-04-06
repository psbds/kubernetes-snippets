#/bin/bash
# Author: Paulo Baima
# Source: https://github.com/psbds/kubernetes-snippets

# Default Args
{
    VERBOSE=0
    CONTAINER="velero-backup"
    SUBSCRIPTION="$(az account show --query id -o tsv)"
    LOCATION="GRS"
    STORAGE_NAME="velero$(uuidgen | cut -d '-' -f5 | tr '[A-Z]' '[a-z]')"
}

arguments=( 
    "-g|--resource-group:RESOURCE_GROUP"
    "-c|--container:CONTAINER"
    "-s|--subscription:SUBSCRIPTION"
    "-l|--location:LOCATION"
    "-n|--name:STORAGE_NAME"
    "-h|--help:create-velero-vault"
    "-v|--verbose" )

# Source: cli/helpers.bash
read_args arguments $@

validate_args(){
    VALID=1
    validate_empty "$RESOURCE_GROUP"        "Argument -g, --resource-group is required.\n"

    if [ $VALID == 0 ]; then exit 1; fi    
}

validate_args