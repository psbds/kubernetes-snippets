#/bin/bash
# Author: Paulo Baima
# Source: https://github.com/psbds/kubernetes-snippets
DIR="${BASH_SOURCE%/*}" ; if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi
source $DIR/_help.bash

case $1 in
    create-velero-vault)    shift && load "backup/create-velero-vault/index.bash" $@ ;;
    install-velero)         shift && load "backup/install-velero/index.bash" $@ ;;
    uninstall-velero)       shift && load "backup/uninstall-velero/index.bash" $@ ;;
    *) usage "default" ;;
esac