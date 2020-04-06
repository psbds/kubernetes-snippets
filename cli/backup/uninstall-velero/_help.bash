usage(){
    echo "
Remove all velero crds from the cluster.

See more at: $(printInfo https://github.com/psbds/kubernetes-snippets/tree/master/backup/uninstall-velero)

Examples: 

    # Create the velero Vault
    akssnipets backup uninstall-velero
    
Additional Arguments:
    -h,     --help                                : Show this message and exit.
    -v,     --verbose                             : Increase logging verbosity.
"
}