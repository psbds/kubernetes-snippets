#/bin/bash
# Author: Paulo Baima
# Source: https://github.com/psbds/kubernetes-snippets
set -e

local DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi

source $DIR/_help.bash


VERBOSE=0

while [ "$1" != "" ]; do
    case $1 in
        -o | --organization )               shift && ORGANIZATION_NAME=$1
                                            ;;
        -p | --project )                    shift && PROJECT_NAME=$1
                                            ;;
        -pat | --personal-access-token )    shift && PERSONAL_ACCESS_TOKEN=$1
                                            ;;
        -u | --user )                       shift && USER=$1
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
    validate_empty "$ORGANIZATION_NAME"         "Argument -o, --organization is required.\n"
    validate_empty "$PROJECT_NAME"              "Argument -p, --project is required.\n"
    validate_empty "$PERSONAL_ACCESS_TOKEN"     "Argument -pat, --personal-access-token is required.\n"
    validate_empty "$USER"                      "Argument -u, --user is required.\n"

    if [ $VALID == 0 ]
    then
        exit 1;
    fi    
}

validate_args