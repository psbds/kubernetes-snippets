#/bin/bash
# Author: Paulo Baima
# Source: https://github.com/psbds/kubernetes-snippets

while [ "$1" != "" ]; do
    case $1 in
        -o | --organization )               shift && ORGANIZATION_NAME=$1
                                            ;;
        -p | --project )                    shift && PROJECT_NAME=$1
                                            ;;
        -pat | --personal-access-token )    shift && PERSONAL_ACCESS_TOKEN=$1
                                            ;;
        -u | --user )                       shift && USER=$1
        ;;
    esac
    shift
done

create_kubernetes_roles(){
cat <<EOF | kubectl apply -f -
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
  name: binding-az-devops
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: az-devops
subjects:
- kind: ServiceAccount
  name: az-devops
  namespace: az-devops
EOF
}

create_service_account(){
    # Create Kubernetes Namespace and Service Account
    kubectl create namespace az-devops
    kubectl create serviceaccount az-devops -n az-devops
}

create_azdevops_service_connection(){
    SERVICE_CONNECTION_NAME=$(kubectl config view --minify -o jsonpath={.clusters[0].name})

    # Get parameters for curl request to Azure DevOps
    SERVER_URL=$(kubectl config view --minify -o jsonpath={.clusters[0].cluster.server})
    SECRET_NAME=$(kubectl get serviceAccounts az-devops -n az-devops -o=jsonpath={.secrets[*].name})
    TOKEN=$(kubectl get secret $SECRET_NAME -n az-devops -o jsonpath="{.data.token}")
    CERTIFICATE_TOKEN=$(kubectl get secret $SECRET_NAME -n az-devops -o jsonpath="{.data.ca\.crt}")

    curl -X POST \
    'https://dev.azure.com/'$ORGANIZATION_NAME'/'$PROJECT_NAME'/_apis/serviceendpoint/endpoints?api-version=5.1-preview.2' \
    -H 'cache-control: no-cache' \
    -H 'content-type: application/json' \
    -u $USER:$PERSONAL_ACCESS_TOKEN \
    -d '{
                "data": {
                    "authorizationType": "ServiceAccount"
                },
                "name": "'$SERVICE_CONNECTION_NAME'",
                "type": "kubernetes",
                "url": "'$SERVER_URL'",
                "description": "",
                "authorization": {
                    "parameters": {
                        "serviceAccountCertificate": "'$CERTIFICATE_TOKEN'",
                        "apitoken": "'$TOKEN'",
                        "isCreatedFromSecretYaml": "true"
                    },
                    "scheme": "Token"
                },
                "isShared": false,
                "owner": "Library",
                "serviceEndpointProjectReferences": [
                    {
                        "projectReference": {
                            "name": "'$PROJECT_NAME'"
                        },
                        "name": "'$SERVICE_CONNECTION_NAME'",
                        "description": ""
                    }
                ]
            }' 
}

create_kubernetes_roles
create_service_account
create_azdevops_service_connection