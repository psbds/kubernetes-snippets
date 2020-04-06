#/bin/bash
# Author: Paulo Baima
# Source: https://github.com/psbds/kubernetes-snippets
DIR="${BASH_SOURCE%/*}" ; if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi

# Default Args
VERBOSE=0
BACKUP_SUBSCRIPTION="$(az account show --query id -o tsv)"
CLUSTER_SUBSCRIPTION=$BACKUP_SUBSCRIPTION

while [ "$1" != "" ]; do
    case $1 in
        -bs  | --backup-subscription  )       shift && BACKUP_SUBSCRIPTION=$1       ;;
        -brg | --backup-resource-group )      shift && BACKUP_RESOURCE_GROUP=$1     ;;
        -bsa | --backup-storage-account )     shift && BACKUP_STORAGE_ACCOUNT=$1    ;;
        -bc  | --backup-container )           shift && BACKUP_CONTAINER=$1          ;;
        -cs  | --cluster-subscription )       shift && CLUSTER_SUBSCRIPTION=$1      ;;
        -crg | --cluster-resource-group )     shift && CLUSTER_RESOURCE_GROUP=$1    ;;      
        -h   | --help )                       usage "install-velero" && exit        ;;
        -v   | --verbose )                    VERBOSE=1
                                            ;;
    esac
    shift
done

validate_args(){
    VALID=1

    validate_empty "$BACKUP_RESOURCE_GROUP"        "Argument -brg, --backup-resource-group is required.\n"
    validate_empty "$BACKUP_STORAGE_ACCOUNT"       "Argument -bsa, --backup-storage-account is required.\n"
    validate_empty "$BACKUP_CONTAINER"             "Argument -bc, --backup-container is required.\n"
    validate_empty "$CLUSTER_RESOURCE_GROUP"       "Argument -crg, --cluster-resource-group is required.\n"

    if [ $VALID == 0 ]; then exit 1; fi    
}

validate_args