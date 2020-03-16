#/bin/bash
# Author: Paulo Baima
# Source: https://github.com/psbds/kubernetes-snippets
set -e

# Loading an Validating Args
DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi
source "$DIR/arguments.bash" 

create_kubernetes_roles(){
  printInfo "1 - Creating Kubernetes Cluster Roles and Cluster Role Bindings\n" $VERBOSE
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
    printInfo "2 - Creating Kubernetes Namespace and Service Account.\n" $VERBOSE
    if [ -z "$(kubectl get namespace az-devops -o name --ignore-not-found)" ]
    then
        printInfo "Creating namespace az-devops - " $VERBOSE
        kubectl create namespace az-devops3
    else
        printInfo "Namespace az-devops already exists. \n" $VERBOSE
    fi
    
    if [ -z "$(kubectl get serviceaccount az-devops -n az-devops -o name --ignore-not-found)" ]
    then
        printInfo "Creating Service Account az-devops - " $VERBOSE
        kubectl create serviceaccount az-devops -n az-devops
    else
        printInfo "Service Account az-devops already exists. \n" $VERBOSE
    fi
}

create_azdevops_service_connection(){
    printInfo "3 - Creating Service Connection on Azure DevOps.\n" $VERBOSE
    SERVICE_CONNECTION_NAME=$(kubectl config view --minify -o jsonpath={.clusters[0].name})

    # Get parameters for curl request to Azure DevOps
    SERVER_URL=$(kubectl config view --minify -o jsonpath={.clusters[0].cluster.server})
    SECRET_NAME=$(kubectl get serviceAccounts az-devops -n az-devops -o=jsonpath={.secrets[*].name})
    TOKEN=$(kubectl get secret $SECRET_NAME -n az-devops -o jsonpath="{.data.token}")
    CERTIFICATE_TOKEN=$(kubectl get secret $SECRET_NAME -n az-devops -o jsonpath="{.data.ca\.crt}")

    RES=$(curl -L -w "%{http_code} %{url_effective}\\n" -X POST  \
    'https://dev.azure.com/'$ORGANIZATION_NAME'/'$PROJECT_NAME'/_apis/serviceendpoint/endpoints?api-version=5.1-preview.2' \
    -H 'cache-control: no-cache' \
    -H 'content-type: application/json' \
    -u $USER:$PERSONAL_ACCESS_TOKEN \
    -d '{
                "data": {
                    "authorizationType": "ServiceAccount"
                },
                "name": "'$SERVICE_CONNECTION_NAME'szsc",
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
            }') 

    printInfo "Response: \n$RES \n"
}

printInfo "Setting up Service Account connection to Azure DevOps...\n"

create_kubernetes_roles
create_service_account
create_azdevops_service_connection