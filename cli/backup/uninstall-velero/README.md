## Kubernetes Snippets CLI (backup/uninstall-velero)

Create a new Velero Vault to store/retrieve backups.

### Usage

```
# Remove all velero crds from the cluster.
akssnipets backup uninstall-velero
```

### Arguments

| Arguments 	                | Type      | Default                   | Required  | Description 	|
|-----------	                |------     |---------                  |--------   |-------------	|
| -v, --verbose                 |           |                           | no        | Increase logging verbosity.|
| -h, --help                    |           |                           | no        | Show help message.|