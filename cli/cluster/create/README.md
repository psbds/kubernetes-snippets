## Kubernetes Snippets CLI (cluster/create)

Creates new AKS Cluster on Azure

### Usage

```
# Creates a AKS Cluster on Azure
akssnippets cluster create -n myAks -g myRg

# Creates a AKS Cluster on Azure in a specific Subscription
akssnipets cluster create -n myAks -g myRg -s c684894a77c811eabc550242ac130003

# Creates a AKS Cluster on Azure Integrated with Azure AAD
# See: https://github.com/psbds/kubernetes-snippets/tree/master/kubernetes-permissions
akssnipets cluster create -n myAks -g myRg \\
        --aad-server-app-id 9f9f431077c811eabc550242ac130003 --aad-server-app-secret a678588477c811eabc550242ac130003 \\
        --aad-client-app-id ad2fcacc77c811eabc550242ac130003 --aad-tenant-id b19762be77c811eabc550242ac130003
```

### Arguments

| Arguments 	            	| Type  	| Default                   | Required  | Description 	|
|-----------	            	|------ 	|---------                  |--------   |-------------	|
| -n, --name                	| string	| empty                     | yes       | Name of the AKS Cluster to be created.|
| -g, --resource-group      	| string	| empty                     | yes       | Name of the resource group where the AKS Service will be created.|
| -s, --subscription        	| string	| current azure subscription| no        | Id of the subscription where the AKS Cluster will be created.|
| -l, --location            	| string	| eastus2                   | no        | Location where the AKS Cluster will be created.|
| --login                   	| string	| empty                     | no        | Run get-credentials to get kubeconfig after cluster creation. Accepted Values: 'user' or 'admin'|
| -min, --min-nodes         	| number	| 1                         | no        | The minimum number of nodes for the default nodepool.|
| -max, --max-nodes         	| number	| 1                         | no        | The maximum number of nodes for the default nodepool.|
| -vm, --vm-size            	| string	| Standard_DS2_v2           | no        | Size of Virtual Machines for the default nodepool.  Default: Standard_DS2_v2.|
| -k, --kubernetes-version  	| string	| `1.16.7`                  | no        | Version of Kubernetes to use for creating the  cluster, such as "1.16.7" or "1.17.0".  Values from: "az aks get-versions"|
| -ng, --node-resource-group	| string	| MC_aksName_rgName_region  | no        | The node resource group is the resource group where all customer's resources will be created in, such as virtual machines.|

<br/>

| Authentication Arguments 		| Type  	| Default  | Required  | Description 	|
|-----------	                |------ 	|--------- |--------   |-------------	|
| -asai, --aad-server-app-id    | string	| empty    | no        | The ID of an Azure Active Directory server application of type "Web app/API". This represents the managed cluster's apiserver (Server application).|
| -asas, --aad-server-app-secret| string	| empty    | no        | The secret of an Azure Active Directory server application.|
| -acai, --aad-client-app-id    | string	| empty    | no        | The ID of an Azure Active Directory client application of type "Native". This application is for user login via kubectl.|
| -ati, --aad-tenant-id         | string	| empty    | no        | The ID of an Azure Active Directory tenant.|

<br/>

| Networking Arguments 	        | Type  	| Default  | Required  | Description 	|
|-----------	                |------		|--------- |--------   |-------------	|
| -vnet                         | string	| empty    | no        | Name of the VNet where the cluster will exists. Leaving it blank creates a new VNET. Use this parameter together with the `-vnet-rg` and `-subnet` parameters.|
| -vnet-rg                      | string	| empty    | no        | Name of the resource group of the VNet where the cluster will exists. Use this parameter together with the `-vnet` and `-subnet` parameters.|     
| -subnet                       | string	| empty    | no        | Name of the Subnet where the cluster will exists. Use this parameter together with the `-vnet-rg` and `-vnet` parameters.|
| -svc-cidr                     | string	| empty    | no        | A CIDR notation IP range from which to assign service cluster IPs. This range must not overlap with any Subnet IP ranges. For example, `10.0.0.0/16`. Use this parameter together with the vnet parameters.|
| -svc-dns-ip                   | string	| empty    | no        | An IP address assigned to the Kubernetes DNS service. This address must be within the Kubernetes service address range specified by "--service-cidr". For example, `10.0.0.10`. Use this parameter together with the vnet parameters.|

<br/>

| Additional Arguments		| Type 		| Default  | Required	| Description 	|
|-----------	      		|------		|--------- |-------- 	|-------------	|
| -v, --verbose       		|      		|          | no      	| Increase logging verbosity.|
| -h, --help          		|      		|          | no      	| Show help message.|

### Default Parameters

Below the parameters being used to create the Cluster, you can change them in inside the [Script](https://github.com/psbds/kubernetes-snippets/blob/master/cli/cluster/create/index.bash).

#### NETWORK_PLUGIN = "azure"
```    
Choose a Network Plugin: https://docs.microsoft.com/en-us/azure/aks/concepts-network#azure-virtual-networks

Azure CNI: https://docs.microsoft.com/en-us/azure/aks/configure-azure-cni
Kubenet: https://docs.microsoft.com/en-us/azure/aks/configure-kubenet
```

#### NETWORK_POLICY = "azure"   - [Reference](https://docs.microsoft.com/en-us/azure/aks/use-network-policies)

#### ADDONS = "monitoring"      - [Reference](https://docs.microsoft.com/en-us/azure/azure-monitor/insights/container-insights-overview)

#### OS_DISK_SIZE = 100 (100GB)

#### LOAD_BALANCER_TYPE = "Standard"
```
Set Load Balancer Type
SKU Comparison: https://docs.microsoft.com/pt-br/azure/load-balancer/concepts-limitations#skus
For production workloads, is recommended to use Standard SKU, but please check the pricing as its price is per rule.
```

#### LOAD_BALANCER_OUTBOUND_IPS = 2
```
Set the number of Outbound IPs for a Cluster with Standard Load Balancer
!Important: Depending on your applications, you can have SNAT exhaustion, increasing the number of outbound IPs should give you need ports to outbound
Please Review: https://docs.microsoft.com/en-us/azure/load-balancer/load-balancer-outbound-connections#snatexhaust
```

#### CLUSTER_AUTOSCALER = 1 - [Reference](https://docs.microsoft.com/en-us/azure/aks/cluster-autoscaler)