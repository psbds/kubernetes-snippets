## Kubernetes Snippets CLI (backup/install-velero)

Install velero crds on the cluster and configure the Velero Vault.

### Usage

```
# 

```

### Arguments
| Arguments 	                    | Type      | Default                   | Required  | Description 	|
|-----------	                    |------     |---------                  |--------   |-------------	|
| -bs, --backup-subscription        | string    | 'az-cli context'          | yes       | Velero Vault Subscription Id. |
| -brg, --backup-resource-group     | string    |                           | yes       | Velero Vault Resource Group. |
| -bsa, --backup-storage-account    | string    |                           | yes       | Velero Vault Stourage Account. |
| -bc, --backup-container           | string    |                           | yes       | Velero Vault Container. |
| -cs, --cluster-subscription       | string    |                           | yes       | AKS Cluster Subscription Id. |
| -crg, --cluster-resource-group    | string    |                           | yes       | AKS Cluster Resource Group for Azure Sources (e.g. MC_*)|

<br/>

| Additional Arguments          | Type      | Default                   | Required  | Description 	|
|-----------	                |------     |---------                  |--------   |-------------	|
| -v, --verbose                 |           |                           | no        | Increase logging verbosity.|
| -h, --help                    |           |                           | no        | Show help message.|