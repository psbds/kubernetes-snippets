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

| Paremeter 	| type 	| default 	| Description 	|
|-----------	|------	|---------	|-------------	|
| AZURE_BACKUP_SUBSCRIPTION_ID          	| string      	|  empty       	| The subscription where the storge account for backup will be created, currently, this script doesn't support to backup between subscriptions that are on different Azure AD tenants            	|
| AZURE_BACKUP_RESOURCE_GROUP          	| string     	| ```backup```         	| The resource group where the storage account for backup will be created             	|
| BLOB_CONTAINER           	| string      	| ```velero-backup```         	| The name of the container where the backup will be stored             	|
| LOCATION          	| string      	| ```southcentralus```         	| Region where the backup will be stored, to use GRS storage, just set the variable to ```GRS```             	|
|           	|      	|         	|             	|
|           	|      	|         	|             	|
|           	|      	|         	|             	|
|           	|      	|         	|             	|
|           	|      	|         	|             	|