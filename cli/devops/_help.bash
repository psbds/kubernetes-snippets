#/bin/bash
# Author: Paulo Baima
# Source: https://github.com/psbds/kubernetes-snippets
set -e

usage(){
    echo "
DevOps utilities for Kubernetes.

See more at: $(printInfo https://github.com/psbds/kubernetes-snippets/tree/master/devops)

Commands: 

    create-service-connection                       Creates a Service Connection for Azure DevOps.
"
    
}