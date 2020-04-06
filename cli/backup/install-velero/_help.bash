usage(){
    echo "
Install velero crds on the cluster and configure the Velero Vault.

See more at: $(printInfo https://github.com/psbds/kubernetes-snippets/tree/master/backup/install-velero)

Be sure to be in the right Kubernetes Context before running the command. Run `kubectl config current-context` to see your current context

Examples: 

# Install Velero in the AKS Cluster  
akssnippets backup install-velero -brg vault-rg -bsa myvelerobackup -bc velero-vault -crg MC_myAks_myAksRg_eastus2
    
Arguments:
  -bc, --backup-container           [Required]  Velero Vault Container.
  -brg, --backup-resource-group     [Required]  Velero Vault Resource Group.
  -bsa, --backup-storage-account    [Required]  Velero Vault Stourage Account.
  -crg, --cluster-resource-group    [Required]  AKS Cluster Resource Group for Azure Sources (e.g. MC_*).
  -bs, --backup-subscription                    Velero Vault Subscription Id.
  -cs, --cluster-subscription                   AKS Cluster Subscription Id.
    
Additional Arguments:
    -h,     --help                                : Show this message and exit.
    -v,     --verbose                             : Increase logging verbosity.
"
}