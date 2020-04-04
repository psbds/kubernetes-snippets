## Kubernetes Snippets CLI (backup/create-velero-vault)

Create a new Velero Vault to store/retrieve backups.

### Usage

```
# Create a Velero Vault
akssnippets backup create-velero-vault -g abc -s abcdefgh-jklmnopq-rstuvw-xyz1
```

### Arguments

| Arguments 	                | Type      | Default                   | Required  | Description 	|
|-----------	                |------     |---------                  |--------   |-------------	|
| -g, --resource-group          | string    | empty                     | yes       | Resource Group for the Vault Storage Account.|
| -c, --container               | string    | `velero-container`        | no       | The name of the Container inside of the Blob Storage, where the Backups will be stored.|
| -s, --subscription            | string    | `az-cli context`          | no        | Subscription for the Vault Storage Account.|
| -l, --location                | string    | `GRS`                     | no       | The Location where the storage account will store the backups, use GRS for GRS Storage.|
| -sn, --storage-name           | string    | auto-generated            | no        | The name of the Storage Account that will be created, you can provide your own name (making sure that is unique, alphanumeric and all lowercase)|

<br/>

| Additional Arguments 	        | Type      | Default                   | Required  | Description 	|
|-----------	                |------     |---------                  |--------   |-------------	|
| -v, --verbose                 |           |                           | no        | Increase logging verbosity.|
| -h, --help                    |           |                           | no        | Show help message.|