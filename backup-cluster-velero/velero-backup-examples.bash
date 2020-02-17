# Create backup from Default Namespace
velero backup create backup1 --include-namespaces default

# Restore backup1 from to the 'example' namespace
kubectl create namespace example
velero restore create restore-2 --namespace-mappings default:example --from-backup backup1