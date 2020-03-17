# Create a service principal and read in the application ID
# SP=$(az ad sp create-for-rbac --name $SP_NAME --output json) # Use this one if you want to set the Service Principal name
printInfo "Creating Service Principal: " $VERBOSE
SP=$(az ad sp create-for-rbac --output json)
SP_ID=$(echo $SP | jq -r .appId)
SP_PASSWORD=$(echo $SP | jq -r .password)

# Wait 15 seconds to make sure that service principal has propagated
echo "Waiting for service principal to propagate..."
sleep 15


# Assign the service principal Contributor permissions to the virtual network resource
az role assignment create --assignee $SP_ID --scope $VNET_ID'' --role Contributor -o none

printInfo "Done.\n" $VERBOSE
