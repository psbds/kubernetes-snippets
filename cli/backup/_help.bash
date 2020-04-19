declare -A help

help=( 
    ["default"]="
Kubernetes Snippets for Backup. 

See more at: $(printInfo https://github.com/psbds/kubernetes-snippets/tree/master/backup)

Commands: 

    crate-velero-vault      Create a new Velero Vault to store/retrieve backups.
    install-velero          Install velero crds on the cluster and configure the Velero Vault.
    uninstall-velero        Remove all velero crds from the cluster.

Arguments:

    -h,     --help      : Show this message and exit.
"
    ["uninstall-velero"]="
Remove all velero crds from the cluster.

See more at: $(printInfo https://github.com/psbds/kubernetes-snippets/tree/master/backup/uninstall-velero)

Examples: 

    # Remove all velero crds from the cluster.
    akssnippets backup uninstall-velero
    
Additional Arguments:
    -h,     --help      : Show this message and exit.
    -v,     --verbose   : Increase logging verbosity.
"

    ["install-velero"]="
Install velero crds on the cluster and configure the Velero Vault.

See more at: $(printInfo https://github.com/psbds/kubernetes-snippets/tree/master/backup/install-velero)

Be sure to be in the right Kubernetes Context before running the command. Run `kubectl config current-context` to see your current context

Examples: 

# Install Velero in the AKS Cluster  
akssnippets backup install-velero -brg vault-rg -bsa myvelerobackup -bc velero-vault -crg MC_myAks_myAksRg_eastus2
    
Arguments:
  -bc, --backup-container           [Required]  : Velero Vault Container.
  -brg, --backup-resource-group     [Required]  : Velero Vault Resource Group.
  -bsa, --backup-storage-account    [Required]  : Velero Vault Stourage Account.
  -crg, --cluster-resource-group    [Required]  : AKS Cluster Resource Group for Azure Sources (e.g. MC_*).
  -bs, --backup-subscription                    : Velero Vault Subscription Id.
  -cs, --cluster-subscription                   : AKS Cluster Subscription Id.
    
Additional Arguments:
    -h,     --help                              : Show this message and exit.
    -v,     --verbose                           : Increase logging verbosity.
"

    ["create-velero-vault"]="
Create a new Velero Vault to store/retrieve backups.

See more at: $(printInfo https://github.com/psbds/kubernetes-snippets/tree/master/backup/create-velero-vault)

Examples: 

    # Create the velero Vault
    akssnippets backup create-velero-vault -g myRg

    # Creates a AKS Cluster on Azure in a specific Subscription
    akssnippets backup create-velero-vault -g myRg -s abcdefgh-jklmnopq-rstuvw-xyz1

    # Creates a AKS Cluster on Azure in a specific region
    akssnippets backup create-velero-vault -g myRg -l southcentralus
    
Arguments:
    -g,     --resource-group    [Required]  : Resource Group for the Vault Storage Account.
    -c,     --container                     : The name of the Container inside of the Blob Storage, where the Backups will be stored.
    -l,     --location                      : Location where the storage account will store the backups, use GRS for GRS Storage.
    -n,     --name                          : The name of the Storage Account that will be created, 
                                              should be is unique, alphanumeric and all lowercase.
    -s,     --subscription                  : Subscription Id for the Vault Storage Account.
    
Additional Arguments:
    -h,     --help                          : Show this message and exit.
    -v,     --verbose                       : Increase logging verbosity.
")

usage(){
    echo "${help[$1]}"
}