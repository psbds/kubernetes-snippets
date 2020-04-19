# Kubernetes Permissions

The samples shows how to create Cluster Roles on a Kubernetes Cluster

Please see the full Documentation here: https://kubernetes.io/docs/reference/access-authn-authz/rbac/

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

## Checking Permissions

As Cluster admin you can use the impersonation feature on Kubernetes to check if an user, group or service account has permission to a particular resource

#### To Check access if a service account has permissions to execute `get pods`
```
#kubectl auth can-i --as system:serviceaccount:(NAMESPACE):(SERVICEACCOUNT) get pods
kubectl auth can-i --as system:serviceaccount:default:my-service-account get pods
```

#### To Check access if a user  has permissions to execute `get pods`
```
#kubectl auth can-i --as <userobjectid or email> get pods
kubectl auth can-i --as admin@contoso.com get pods
```

#### To Check access if a group has permissions to execute `get pods`
```
#kubectl auth can-i --as-group <<GROUP_OBJECT_ID>> --as-group=system:authenticated --as anyone get pods   
kubectl auth can-i --as-group myaadgroup --as-group=system:authenticated --as anyone get pods 
```