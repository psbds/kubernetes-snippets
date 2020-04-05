## Kubernetes Snippets CLI (backup/create-velero-vault)

Create a new Velero Vault to store/retrieve backups.

### Usage

```
# Create the velero Vault
akssnipets backup create-velero-vault -g myRg

# Creates a AKS Cluster on Azure in a specific Subscription
akssnipets backup create-velero-vault -g myRg -s abcdefgh-jklmnopq-rstuvw-xyz1

# Creates a AKS Cluster on Azure in a specific region
akssnipets backup create-velero-vault -g myRg -l southcentralus
```

### Arguments

| Arguments 	                | Type      | Default                   | Required  | Description 	|
|-----------	                |------     |---------                  |--------   |-------------	|
| -c, --container               | string    | `velero-container`        | no        | The name of the Container inside of the Blob Storage, where the Backups will be stored.|
| -l, --location                | string    | `GRS`                     | no        | The Location where the storage account will store the backups, use GRS for GRS Storage.|
| -g, --resource-group          | string    | empty                     | yes       | Resource Group for the Vault Storage Account.|
| -n, --name                    | string    | auto-generated            | no        | The name of the Storage Account that will be created, you can provide your own name should be unique, alphanumeric and all lowercase|
| -s, --subscription            | string    | `az-cli context`          | no        | Subscription Id for the Vault Storage Account.|

<br/>

| Additional Arguments 	        | Type      | Default                   | Required  | Description 	|
|-----------	                |------     |---------                  |--------   |-------------	|
| -v, --verbose                 |           |                           | no        | Increase logging verbosity.|
| -h, --help                    |           |                           | no        | Show help message.|