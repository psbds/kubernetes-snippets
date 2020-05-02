## Kubernetes Snippets CLI (cluster)

Backup Tools

### Commands


* ```create-velero-vault``` - Create a new Velero Vault to store/retrieve backups. [See Docs.](https://github.com/psbds/kubernetes-snippets/tree/master/cli/backup/create-velero-vault)
* ```install-velero``` - Install velero crds on the cluster and configure the Velero Vault. [See Docs.](https://github.com/psbds/kubernetes-snippets/tree/master/cli/cluster/install-velero)
* ```uninstall-velero``` - Remove all velero crds from the cluster. [See Docs.](https://github.com/psbds/kubernetes-snippets/tree/master/cli/cluster/uninstall-velero)

### Arguments

| Arguments 	                | Type      | Default                   | Required  | Description 	|
|-----------	                |------     |---------                  |--------   |-------------	|
| -h, --help                    |           |                           | no        | Show help message.|


### Velero

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

To create the vault, you can use use the `akssnippets backup create-velero-vault` command. - **[Reference](https://github.com/psbds/kubernetes-snippets/tree/master/cli/backup/create-velero-vault)**

## Setup AKS Cluster to use the Vault

The next step, is to install velero in the cluster with the configuration pointing to the backup vault.

I will run those steps in two situations:
1. You already have a cluster and want do to backups to the vault
2. You created a new cluster and want to restore backups from the vault 

To install velero, you can use the `akssnippets backup install-velero` command. - **[Reference](https://github.com/psbds/kubernetes-snippets/blob/master/backup/velero-install.bash)**    |

## Velero Basic Commands

### Backup

Check Available Commands and Parameters

```velero backup --help```

* Create a backup: ```velero backup create --help```

* Delete backups: ```velero backup delete  --help```

* Describe backups: ```velero backup describe  --help```

* Download a backup: ```velero backup download  --help```

* Get backups: ```velero backup get --help```

* Get backup logs: ```velero backup logs --help```

#### Examples

* Manually Backup the entire cluster: ```velero backup create backup1```

* Manually Backup specifc namespaces: ```velero backup create backup1 --include-namespaces default,mynamespace```

* Manually with Cluster Resources (Ex: ClusteRole and ClusterRoleBindings): ```velero backup create backup1 --include-cluster-resources=true```

### Scheduled Backup

Check Available Commands and Parameters

```velero schedule --help```

* Create a schedule: ```velero schedule create --help```

* Delete schedule: ```velero schedule delete  --help```

* Describe schedule: ```velero schedule describe  --help```

* Get schedule: ```velero schedule get --help```

#### Examples

* Schedule Backup for every six hours: ```velero create schedule backup-schedule --schedule="0 */6 * * *"```

* Schedule Backup for every six hours for specifc namespaces: Example: ```velero create schedule backup-schedule --schedule="0 */6 * * *" --include-namespaces default,mynamespace```

* Schedule Backup for every six hours with Cluster Resources (Ex: ClusteRole and ClusterRoleBindings): ```velero create schedule backup-schedule --schedule="0 */6 * * *" --include-cluster-resources=true```

### Restore

Check Available Commands and Parameters

```velero restore --help```

* Create a restore: ```velero restore create --help```

* Delete restore: ```velero restore delete  --help```

* Describe restore: ```velero restore describe  --help```

* Get restore: ```velero restore get --help```

* Get restore logs: ```velero restore logs --help```

#### Examples

* Restore from Backup: ```velero restore create restore1 --from-backup backup1```

* Restore from the last sucessfull backup from a backup schedule: ```velero restore create restore-schedule1 --from-schedule backup-schedule```

* Restore from backup to a different namespace: ```velero restore create restore2 --namespace-mappings default:new-namespace --from-backup backup1```


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