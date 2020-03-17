## Kubernetes Snippets CLI (devops/create-service-connection)

Creates new AKS Cluster on Azure

### Usage

```
# Creates a AKS Cluster on Azure
akssnipets cluster create -n myAks -g myRg

# Creates a AKS Cluster on Azure in a specific Subscription
akssnipets cluster create -n myAks -g myRg -s abcdefgh-jklmnopq-rstuvw-xyz1

# Creates a AKS Cluster on Azure Integrated with Azure AAD
akssnipets cluster create -n myAks -g myRg \\
        --aad-server-app-id abcdefgh-jklmnopq-rstuvw-xyz1 --aad-server-app-secret abcdefgh-jklmnopq-rstuvw-xyz1 \\
        --aad-client-app-id abcdefgh-jklmnopq-rstuvw-xyz1 --aad-tenant-id abcdefghjklmnopq
```

### Arguments

| Arguments 	                | Type      | Default                   | Required  | Description 	|
|-----------	                |------     |---------                  |--------   |-------------	|
| -n, --name                    | string    | empty                     | yes       | Name of the AKS Cluster to be created.|
| -g, --resource-group          | string    | empty                     | yes       | Name of the resource group where the AKS Service will be created.|
| -s, --subscription            | string    | current azure subscription| no        | Id of the subscription where the AKS Cluster will be created.|
| -l, --location                | string    | eastus2                   | no        | Location where the AKS Cluster will be created.|
| -min, --min-nodes             | number    | 1                         | no        | The minimum number of nodes for the default nodepool.|
| -max, --max-nodes             | number    | 1                         | no        | The maximum number of nodes for the default nodepool.|
| -asai, --aad-server-app-id    | string    | empty                     | no        | The ID of an Azure Active Directory server application of type "Web app/API". This represents the managed cluster's apiserver (Server application).|
| -asas, --aad-server-app-secret| string    | empty                     | no        | The secret of an Azure Active Directory server application.|
| -acai, --aad-client-app-id    | string    | empty                     | no        | The ID of an Azure Active Directory client application of type "Native". This application is for user login via kubectl.|
| -ati, --aad-tenant-id         | string    | empty                     | no        | The ID of an Azure Active Directory tenant.|
| -ng, --node-resource-group    | string    | MC_aksName_rgName_region  | no        | The node resource group is the resource group where all customer's resources will be created in, such as virtual machines.|
| -v, --verbose                 |           |                           | no        | Increase logging verbosity.|
| -h, --help                    |           |                           | no        | Show help message.|