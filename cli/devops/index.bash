#/bin/bash
# Author: Paulo Baima
# Source: https://github.com/psbds/kubernetes-snippets
DIR="${BASH_SOURCE%/*}" ; if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi
source $DIR/_help.bash

case $1 in
    create-service-connection)  shift && load "devops/create-service-connection/index.bash" $@ ;;
    *) usage "default" ;;
esac