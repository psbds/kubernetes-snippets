#/bin/bash
# Author: Paulo Baima
# Source: https://github.com/psbds/kubernetes-snippets
DIR="${BASH_SOURCE%/*}" ; if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi

source $DIR/../_help.bash

# Default Args
while [ "$1" != "" ]; do
    case $1 in
        -h | --help )                       usage  "uninstall-velero" && exit   ;;
        -v | --verbose )                    VERBOSE=1                           ;;
    esac
    shift
done