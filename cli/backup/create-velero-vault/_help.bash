usage(){
    echo "
Create a new Velero Vault to store/retrieve backups.

See more at: $(printInfo https://github.com/psbds/kubernetes-snippets/tree/master/backup/create-velero-vault)

Examples: 

    # Create the velero Vault
    akssnipets backup create-velero-vault -g myRg

    # Creates a AKS Cluster on Azure in a specific Subscription
    akssnipets backup create-velero-vault -g myRg -s abcdefgh-jklmnopq-rstuvw-xyz1

    # Creates a AKS Cluster on Azure in a specific region
    akssnipets backup create-velero-vault -g myRg -l southcentralus
    
Arguments:
    -g,     --resource-group         [Required]   : Resource Group for the Vault Storage Account.
    -c,     --container                           : The name of the Container inside of the Blob Storage, where the Backups will be stored.
    -l,     --location                            : Location where the storage account will store the backups, use GRS for GRS Storage.
    -n,     --name                                : The name of the Storage Account that will be created, 
                                                    should be is unique, alphanumeric and all lowercase.
    -s,     --subscription                        : Subscription Id for the Vault Storage Account.
    
Additional Arguments:
    -h,     --help                                : Show this message and exit.
    -v,     --verbose                             : Increase logging verbosity.
"
}