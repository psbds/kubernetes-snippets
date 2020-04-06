## Kubernetes Snippets CLI (backup/install-velero)

Install velero crds on the cluster and configure the Velero Vault.

### Usage

```
# Be sure to be in the right Kubernetes Context before running the command.
# Run `kubectl config current-context` to see your current context
# Install Velero in the AKS Cluster  
akssnippets backup install-velero -brg vault-rg -bsa myvelerobackup -bc velero-vault -crg MC_myAks_myAksRg_eastus2
```

### Arguments
| Arguments 	                    | Type      | Default           | Required  | Description 	|
|-----------	                    |------     |---------          |--------   |-------------	|
| -bs, --backup-subscription        | string    | 'az-cli context'  | no        | Velero Vault Subscription Id. |
| -brg, --backup-resource-group     | string    |                   | yes       | Velero Vault Resource Group. |
| -bsa, --backup-storage-account    | string    |                   | yes       | Velero Vault Stourage Account. |
| -bc, --backup-container           | string    |                   | yes       | Velero Vault Container. |
| -cs, --cluster-subscription       | string    | 'az-cli context'  | no        | AKS Cluster Subscription Id. |
| -crg, --cluster-resource-group    | string    |                   | yes       | AKS Cluster Resource Group for Azure Sources (e.g. MC_*).|

<br/>

| Additional Arguments          | Type      | Default                   | Required  | Description 	|
|-----------	                |------     |---------                  |--------   |-------------	|
| -v, --verbose                 |           |                           | no        | Increase logging verbosity.|
| -h, --help                    |           |                           | no        | Show help message.|