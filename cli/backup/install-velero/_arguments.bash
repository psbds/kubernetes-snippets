#/bin/bash
# Author: Paulo Baima
# Source: https://github.com/psbds/kubernetes-snippets

# Default Args
{
    VERBOSE=0
    BACKUP_SUBSCRIPTION="$(az account show --query id -o tsv)"
    CLUSTER_SUBSCRIPTION=$BACKUP_SUBSCRIPTION
}

arguments=( 
    "-bs|--backup-subscription:BACKUP_SUBSCRIPTION"
    "-brg|--backup-resource-group:BACKUP_RESOURCE_GROUP"
    "-bsa|--backup-storage-account:BACKUP_STORAGE_ACCOUNT"
    "-bc|--backup-container:BACKUP_CONTAINER"
    "-cs|--cluster-subscription:CLUSTER_SUBSCRIPTION"
    "-crg|--cluster-resource-group:CLUSTER_RESOURCE_GROUP"
    "-h|--help:install-velero"
    "-v|--verbose" )

# Source: cli/helpers.bash
read_args arguments $@

validate_args(){
    VALID=1

    validate_empty "$BACKUP_RESOURCE_GROUP"        "Argument -brg, --backup-resource-group is required.\n"
    validate_empty "$BACKUP_STORAGE_ACCOUNT"       "Argument -bsa, --backup-storage-account is required.\n"
    validate_empty "$BACKUP_CONTAINER"             "Argument -bc, --backup-container is required.\n"
    validate_empty "$CLUSTER_RESOURCE_GROUP"       "Argument -crg, --cluster-resource-group is required.\n"

    if [ $VALID == 0 ]; then exit 1; fi    
}

validate_args