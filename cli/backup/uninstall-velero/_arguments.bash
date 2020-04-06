#/bin/bash
# Author: Paulo Baima
# Source: https://github.com/psbds/kubernetes-snippets
DIR="${BASH_SOURCE%/*}" ; if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi
source $DIR/../_help.bash


arguments=( 
    "-h|--help:uninstall-velero"
    "-v|--verbose" )

# Source: cli/helpers.bash
read_args arguments $@