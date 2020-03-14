# Parameters
ORGANIZATION_NAME="contoso"
PROJECT_NAME="contosoProject"
PERSONAL_ACCESS_TOKEN="abczxc"
USER="admin@contoso.com"
SERVICE_CONNECTION_NAME=$(kubectl config view --minify -o jsonpath={.clusters[0].name})

# Create Kubernetes Namespace and Service Account
kubectl create namespace az-devops
kubectl create serviceaccount az-devops -n az-devops

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