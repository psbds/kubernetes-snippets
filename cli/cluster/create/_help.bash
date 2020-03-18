usage(){
    echo "
Creates new AKS Cluster on Azure

See more at: $(printInfo https://github.com/psbds/kubernetes-snippets/tree/master/cluster)

Examples: 

    # Creates a AKS Cluster on Azure
    akssnipets cluster create -n myAks -g myRg

    # Creates a AKS Cluster on Azure in a specific Subscription
    akssnipets cluster create -n myAks -g myRg -s abcdefgh-jklmnopq-rstuvw-xyz1

    # Creates a AKS Cluster on Azure Integrated with Azure AAD
    # See: https://github.com/psbds/kubernetes-snippets/tree/master/kubernetes-permissions
    akssnipets cluster create -n myAks -g myRg \\
            --aad-server-app-id abcdefgh-jklmnopq-rstuvw-xyz1 --aad-server-app-secret abcdefgh-jklmnopq-rstuvw-xyz1 \\
            --aad-client-app-id abcdefgh-jklmnopq-rstuvw-xyz1 --aad-tenant-id abcdefghjklmnopq

Arguments:
    -n,     --name                   [Required]   : Name of the AKS Cluster.   
    -g,     --resource-group         [Required]   : Name of the resource group.
    -s,     --subscription                        : Id of the subscription.
    -l,     --location                            : Location. Values from: \"az account list-locations\".
    -min,   --min-nodes                           : Minimum number of nodes for the default node pool.
    -max,   --max-nodes                           : Maximum number of nodes for the default node pool.
    -vm,    --vm-size                             : Size of Virtual Machines to create as Kubernetes
                                                    nodes.  Default: Standard_DS2_v2.
    -k,     --kubernetes-version                  : Version of Kubernetes to use for creating the
                                                    cluster, such as \"1.16.4\" or \"1.17.0\".  Values from:
                                                    \"az aks get-versions\"
    -asai,  --aad-server-app-id                   : The ID of an Azure Active Directory server
                                                    application of type \"Web app/API\". This application
                                                    represents the managed cluster's apiserver (Server
                                                    application).
    -asas,  --aad-server-app-secret               : The secret of an Azure Active Directory server
                                                    application.
    -acai,  --aad-client-app-id                   : The ID of an Azure Active Directory client
                                                    application of type \"Native\". This application is
                                                    for user login via kubectl.
    -ati,   --aad-tenant-id                       : The ID of an Azure Active Directory tenant.
    -ng,    --node-resource-group                 : The node resource group is the resource group where
                                                    all customer's resources will be created in, such as
                                                    virtual machines.
    -h,     --help                                : Show this message and exit.
    -v,     --verbose                             : Increase logging verbosity.
    --login                                       : Run get-credentials to get kubeconfig after cluster creation. Accepted Values: 'user' or 'admin'.
"
}