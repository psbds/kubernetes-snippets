# Create AzureDevOps Service Connections for Kubernetes

On a AAD Integrated cluster, it's recommended to configure the service connection to the cluster using Service Accounts.

To do that you can follow those steps:

## Setting up Service Connection (Manually)

### Creating the Permissions
Create a role with the permissions needed for Azure DevOps to do the deployment, you can refine to have a more granular set of permissions, in this example we're giving full permissions to the service account using the Cluster Role below

```
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRole
metadata:
    name: az-devops
rules:
- apiGroups: ["*"]
    resources: ["*"]
    verbs: ["*"]
---
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRoleBinding
metadata:
    name: binding-admin-az-devops
roleRef:
    apiGroup: rbac.authorization.k8s.io
    kind: ClusterRole
    name: az-devops
subjects:
- kind: ServiceAccount
    name: az-devops
    namespace: az-devops
```


To setup on Azure DevOps, got to your Project Settings and then Service Connections. Create a new Service Connection and select the type = Kubernetes.

Create the new namespace for the serviceaccount, the service account itself and get the configuration to input on Azure DevOps.
```
kubectl create namespace az-devops
kubectl create serviceaccount az-devops -n az-devops

SECRET_NAME=$(kubectl get serviceAccounts az-devops -n az-devops -o=jsonpath={.secrets[*].name})

echo 'Your Server URL is: '$(kubectl config view --minify -o jsonpath={.clusters[0].cluster.server})    
echo 'Your Secret File is:'
echo $(kubectl get secret $SECRET_NAME -n az-devops -o json)
```
## Setting up Service Connection (with Kubernetes Snippets CLI)

You can also use the cli provided in this repo to create the service connection through the Azure DevOps REST API.

[Instructions Here](https://github.com/psbds/kubernetes-snippets/tree/master/cli/devops/create-service-connection) 

## Setting up Service Connection (with Azure Pipelines)

You can setup a pipeline on Azure DevOps using the file `setup-service-connection-pipeline.yaml` file.

This is useful for cases where you create your clusters using a pipeline, in this way, you can also create the service connection altogether.
