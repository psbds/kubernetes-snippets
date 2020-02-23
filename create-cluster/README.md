# Docs under construction

The script on this repository was made to facilitate the creation of AKS Clusters with some default options that are not avilable on Azure Portal.


| Paremeter 	| Type 	| Default 	| Required 	| Description 	|
|-----------	|------	|---------	|--------	|-------------	|
| SUBSCRIPTION_ID          	| string      	|  empty       	| yes | The subscription where the AKS resource will be created.            	|
| RESOURCE_GROUP_NAME| string | empty | yes | The resource group where the AKS resource will be created. |
| AKS_NAME | string | empty | yes | The nane of the AKS resource that will be created. |
| VNET_NAME | string | empty | yes | The name of the VNET that will be created to attach the AKS cluster |
| LOCATION | string | empty | yes | The location where the AKS resources will be created. |
| MIN_NODES | int | 1 | yes | The minimum number of nodes for nodepool autoscalling, also is the initial number of nodes created for the default nodepool |
| | | | | |
| | | | | |
| | | | | | 



