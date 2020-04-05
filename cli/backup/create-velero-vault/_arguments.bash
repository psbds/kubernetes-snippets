#/bin/bash
# Author: Paulo Baima
# Source: https://github.com/psbds/kubernetes-snippets
DIR="${BASH_SOURCE%/*}" ; if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi

source $DIR/_help.bash

# Default Args
VERBOSE=0
CONTAINER="velero-backup"
SUBSCRIPTION="$(az account show --query id -o tsv)"
LOCATION="GRS"
STORAGE_NAME="velero$(uuidgen | cut -d '-' -f5 | tr '[A-Z]' '[a-z]')"

while [ "$1" != "" ]; do
    case $1 in
        -g | --resource-group )             shift && RESOURCE_GROUP=$1  ;;
        -c | --container )                  shift && CONTAINER=$1       ;;
        -s | --subscription )               shift && SUBSCRIPTION=$1    ;;
        -l | --location )                   shift && LOCATION=$1        ;;
        -n | --name )                       shift && STORAGE_NAME=$1    ;;
        -h | --help )                       usage && exit               ;;
        -v | --verbose )                    VERBOSE=1
                                            ;;
    esac
    shift
done

echo "$STORAGE_NAME"

validate_args(){
    VALID=1
    validate_empty "$RESOURCE_GROUP"        "Argument -g, --resource-group is required.\n"

    if [ $VALID == 0 ]
    then
        exit 1;
    fi    
}

validate_args