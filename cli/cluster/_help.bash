#/bin/bash
# Author: Paulo Baima
# Source: https://github.com/psbds/kubernetes-snippets
declare -A help

help=( 
    ["default"]="
Kubernetes Snippets for Cluster Management. 

See more at: $(printInfo https://github.com/psbds/kubernetes-snippets/tree/master/cluster)

Commands: 

    create                      Creates a AKS Cluster on Azure.
    create-aad-credentials      Creates the credentials on Azure Active Directory to integrate AKS with AAD Authentication.

Arguments:

    -h, --help      : Show this message and exit.
"

    ["create"]="
Creates new AKS Cluster on Azure

See more at: $(printInfo https://github.com/psbds/kubernetes-snippets/tree/master/cluster)

Examples: 

    # Creates a AKS Cluster on Azure
    akssnipets cluster create -n myAks -g myRg

    # Creates a AKS Cluster on Azure in a specific Subscription
    akssnipets cluster create -n myAks -g myRg -s c684894a77c811eabc550242ac130003

    # Creates a AKS Cluster on Azure Integrated with Azure AAD
    # See: https://github.com/psbds/kubernetes-snippets/tree/master/kubernetes-permissions
    akssnipets cluster create -n myAks -g myRg \
            --aad-server-app-id 9f9f431077c811eabc550242ac130003 --aad-server-app-secret a678588477c811eabc550242ac130003 \
            --aad-client-app-id ad2fcacc77c811eabc550242ac130003 --aad-tenant-id b19762be77c811eabc550242ac130003

Arguments:
    -n,     --name                  [Required]  : Name of the AKS Cluster.   
    -g,     --resource-group        [Required]  : Name of the resource group.
    -k,     --kubernetes-version                : Version of Kubernetes to use for creating the
                                                  cluster, such as \"1.16.7\" or \"1.17.0\".  Values from:
                                                  \"az aks get-versions\"
    -l,     --location                          : Location. Values from: \"az account list-locations\".
    --login                                     : Run get-credentials to get kubeconfig after cluster creation. Accepted Values: 'user' or 'admin'.
    -max,   --max-nodes                         : Maximum number of nodes for the default node pool.
    -min,   --min-nodes                         : Minimum number of nodes for the default node pool.
    -ng,    --node-resource-group               : The node resource group is the resource group where
                                                  all customer's resources will be created in, such as
                                                  virtual machines.
    -s,     --subscription                      : Id of the subscription.
    -vm,    --vm-size                           : Size of Virtual Machines to create as Kubernetes
                                                  nodes.  Default: Standard_DS2_v2.

Authentication Arguments:                                                    
    -acai,  --aad-client-app-id                 : The ID of an Azure Active Directory client
                                                  application of type \"Native\". This application is
                                                  for user login via kubectl.
    -asai,  --aad-server-app-id                 : The ID of an Azure Active Directory server
                                                  application of type \"Web app/API\". This application
                                                  represents the managed cluster's apiserver (Server
                                                  application).
    -asas,  --aad-server-app-secret             : The secret of an Azure Active Directory server
                                                  application.
    -ati,   --aad-tenant-id                     : The ID of an Azure Active Directory tenant.

Networking Arguments:
    -subnet                                     : Name of the Subnet where the cluster will exists.
                                                  Use this parameter together with the \"-vnet-rg\" and \"-vnet\" parameters.
    -svc-cidr                                   : CIDR notation IP range from which to assign service cluster IPs. 
                                                  This range must not overlap with any Subnet IP ranges. For example, \"10.0.0.0/16\".  
                                                  Use this parameter together with the vnet parameters.
    -svc-dns-ip                                 : An IP address assigned to the Kubernetes DNS service. 
                                                  This address must be within the Kubernetes service address range specified by \"--service-cidr\". For example, \"10.0.0.10\". 
                                                  Use this parameter together with the vnet parameters.
    -vnet                                       : Name of the VNet where the cluster will exists. Leaving it blank creates a new VNET. 
                                                  Use this parameter together with the \"-vnet-rg\" and \"-subnet\" parameters.
    -vnet-rg                                    : Name of the resource group of the VNet where the cluster will exists. 
                                                  Use this paremter parameter with the \"-vnet\" and \"-subnet\" parameters.
                                                    
Additional Arguments:
    -h,     --help                                : Show this message and exit.
    -v,     --verbose                             : Increase logging verbosity.
"

 ["create-aad-credentials"]="
Creates the credentials on Azure Active Directory to integrate AKS with AAD Authentication.

See more at: $(printInfo https://github.com/psbds/kubernetes-snippets/tree/master/cluster)

Examples: 

    # Creates the credentials on Azure Active Directory to integrate AKS with AAD Authentication 
    akssnippets cluster create-aad-credentials -n credentialname

Arguments:
    -n,     --name      [Required]  : Name the Service Principal that will be created.
    
Additional Arguments:
    -h,     --help                  : Show this message and exit.
    -v,     --verbose               : Increase logging verbosity.
")

usage(){
    echo "${help[$1]}"
}