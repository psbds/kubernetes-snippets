#/bin/bash
# Author: Paulo Baima
# Source: https://github.com/psbds/kubernetes-snippets
set -e

usage(){
    echo "
Kubernetes Snippets for Backup. 

See more at: $(printInfo https://github.com/psbds/kubernetes-snippets/tree/master/backup)

Commands: 

    crate-velero-vault                  Create a new Velero Vault to store/retrieve backups.
    install-velero                      Install velero crds on the cluster and configure the Velero Vault.
    uninstall-velero                    Remove all velero crds from the cluster.

Arguments:

    -h,     --help                                : Show this message and exit.
"
    exit
}

case $1 in
    create-velero-vault)    shift && load "backup/create-velero-vault/index.bash" $@ ;;
    install-velero)         shift && load "backup/install-velero/index.bash" $@ ;;
    uninstall-velero)       shift && load "backup/uninstall-velero/index.bash" $@ ;;

    *) usage ;;
esac