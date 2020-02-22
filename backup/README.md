# Backup & Migrate Clusters using Velero

Velero is an open source tool to safely backup and restore, perform disaster recovery, and migrate Kubernetes cluster resources and persistent volumes.

On this repository you will find the basics of Velero (Setting up the backup vault and installing velero in a AKS cluster), along with some snippets to do backup.

Sources:

* [Velero Website](https://velero.io/)
* [Velero Docs](https://velero.io/docs/v1.2.0/)
* [Velero Plugin for Azure](https://github.com/vmware-tanzu/velero-plugin-for-microsoft-azure)

## Setting up Backup Vault

The first step when configuring backup with velero, is to create the vault where the backups will be stored.

Basically, what you need to do is to create a Storage Account on Azure to host the object definitions (services, deployments, pods, etc.) along with Snapshots of any persitent volumes you want to include.

To create the vault, you can use the script listed **[here](https://github.com/psbds/kubernetes-snippets/blob/master/backup/velero-create-vault.bash)**.

This script will require the following paremeters:

| Paremeter 	| Type 	| Default 	| Description 	|
|-----------	|------	|---------	|-------------	|
| AZURE_BACKUP_SUBSCRIPTION_ID          	| string      	|  empty       	| The subscription where the storge account for backup will be created, currently, this script doesn't support to backup between subscriptions that are on different Azure AD tenants.            	|
| AZURE_BACKUP_RESOURCE_GROUP          	| string     	| ```backup```         	| The resource group where the storage account for backup will be created.             	|
| BLOB_CONTAINER           	| string      	| ```velero-backup```         	| The name of the container where the backup will be stored.             	|
| LOCATION          	| string      	| ```southcentralus```         	| Region where the backup will be stored, to use GRS storage, just set the variable to ```GRS```.             	|
| AZURE_STORAGE_ACCOUNT_ID           	| string      	| randomstring         	| The name of the storage account resource that will be created.             	|


## Setup AKS Cluster to use the Vault

The next step, is to install velero in the cluster with the configuration pointing to the backup vault.

I will run those steps in two situations:
1. You already have a cluster and want do to backups to the vault
2. You created a new cluster and want to restore backups from the vault 

To install velero, you can use the script listed **[here](https://github.com/psbds/kubernetes-snippets/blob/master/backup/velero-install.bash)**

| Paremeter 	| Type 	| Default 	| Description 	|
|-----------	|------	|---------	|-------------	|
| AZURE_BACKUP_SUBSCRIPTION               | string       | empty           | The subscription where the Storage Account for backup was created.               |
| AZURE_BACKUP_RESOURCE_GROUP               | string      | empty           | The resource group where the Storage Account for backup was created.               |
| AZURE_BACKUP_STORAGE_ACCOUNT_ID               | string      | empty           | The name of the Storage Account created for backup.              |
| AZURE_BACKUP_CONTAINER               | string       | ```velero-backup```           | The name of the container created for backup.               |
| AZURE_AKS_SUBSCRIPTION               | string       | empty           | The name of the subcription that the AKS resource is created.              |
| AZURE_AKS_MC_RESOURCE_GROUP               | string       | empty           | The name of the resource group where the AKS components are created. Note: This is not the resource group of the AKS resource itself, it's the resource group where AKS creates the virtual machines, load balancers, IPs, etc. Its name Usually start with MC_.    |
|               |       |           |               |

## Velero Basic Commands

### Backup

#### Check Available Commands and Parameters
```velero backup --help```

* Create a backup: ```velero backup create --help```

* Delete backups: ```velero backup delete  --help```

* Describe backups: ```velero backup describe  --help```

* Download a backup: ```velero backup download  --help```

* Get backups: ```velero backup get --help```

* Get backup logs: ```velero backup logs --help```

#### Manually Backup the entire cluster

Example: ```velero backup create backup1```

#### Manually Backup specifc namespaces

Example: ```velero backup create backup1 --include-namespaces default,mynamespace```

#### Manually with Cluster Resources (Ex: ClusteRole and ClusterRoleBindings)

Example: ```velero backup create backup1 --include-cluster-resources=true```

### Scheduled Backup

#### Check Available Commands and Parameters
```velero backup --help```

* Create a schedule: ```velero schedule create --help```

* Delete schedule: ```velero schedule delete  --help```

* Describe schedule: ```velero schedule describe  --help```

* Get schedule: ```velero schedule get --help```

#### Schedule Backup for every six hours

Example: ```velero create schedule backup-schedule --schedule="0 */6 * * *"```

#### Schedule Backup for every six hours for specifc namespaces

Example: ```velero create schedule backup-schedule --schedule="0 */6 * * *" --include-namespaces default,mynamespace```

#### Schedule Backup for every six hours with Cluster Resources (Ex: ClusteRole and ClusterRoleBindings)

Example: ```velero create schedule backup-schedule --schedule="0 */6 * * *" --include-cluster-resources=true```


### Best Practices around Restoring Scheduled Backups

Is a good practice to set the backup vault to readonly before you restore from a scheduled backup, this prevents objects from being overriden while the restore is happening.

```
kubectl patch backupstoragelocation default \
    --namespace velero \
    --type merge \
    --patch '{"spec":{"accessMode":"ReadOnly"}}'

```
After the restore is succeeded you can patch the vault backp to ReadWrite
```
kubectl patch backupstoragelocation default \
       --namespace velero \
       --type merge \
       --patch '{"spec":{"accessMode":"ReadWrite"}}'
```