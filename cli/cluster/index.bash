#/bin/bash
# Author: Paulo Baima
# Source: https://github.com/psbds/kubernetes-snippets
DIR="${BASH_SOURCE%/*}" ; if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi
source $DIR/_help.bash

case $1 in
    create)  shift && load "cluster/create/index.bash" $@ ;;
    create-aad-credentials)  shift && load "cluster/create-aad-credentials/index.bash" $@ ;;
    *) usage "default" ;;
esac