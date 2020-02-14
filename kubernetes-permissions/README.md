# Kubernetes Permissions

The samples shows how to create Cluster Roles on a Kubernetes Cluster

Please see the full Documentation here: https://kubernetes.io/docs/reference/access-authn-authz/rbac/



## AAD Integration

Without the AAD integration, all users with owner/contributor permission to the AKS resource will have **full permissions in the cluster**, and will not be able to differ from one another.

To manage user permission using email or AAD groups, you need to setup [AAD Integration](https://docs.microsoft.com/en-us/azure/aks/kubernetes-service-principal).

I've also created a helper script to create the AAD Integration [here](https://github.com/psbds/kubernetes-snippets/blob/master/create-cluster/setup-aad-connection.bash)

**Not that to create this integration, you need admin rights in Azure Active Directory.**

## Role Types
On Kubernetes, there's to types of Roles

* ClusterRole: which bind to the cluster in general
```
#  This example creates a Cluster Role full permissions for all API's in the Cluster
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRole
metadata:
  name: cluster-admin
rules:
- apiGroups: ["*"]
  resources: ["*"]
  verbs: ["*"]
```
* Roles: which bind to resources inside a namespace
```
# This exmaple create a Role in the default namespace with acess to the 'pods' and 'pods/logs' API with the 'get' and 'list' operations
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: Role
metadata:
  name: pod-reader
  namespace: default
rules:
  - apiGroups: [""]
    resources: ["pods", "pods/logs"]
    verbs: ["get", "list"]
```

## Binding Types

For Bindings, we have the following:


* ClusteRoleBinding: which binds a user, group or service account to a **ClusterRole**
```
# This binding attaches the permissions for the cluster-admin ClusterRole to the admin@contoso.com user
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1beta1
metadata:
  name: binding-cluster-admin
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: User
  name: admin@contoso.com
```
* RoleBinding: which binds a user, group or service account to a **Role**
```
# This bind attaches the permissions for the pod-reader Role to a AAD Group
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: RoleBinding
metadata:
  name: binding-pod-reader
  namespace: default
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: pod-reader
subjects:
- apiGroup: rbac.authorization.k8s.io
  kind: Group
  name: <<AAD_Group_ID>>
```