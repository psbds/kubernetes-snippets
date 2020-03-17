#/bin/bash
# Author: Paulo Baima
# Source: https://github.com/psbds/kubernetes-snippets
set -e

usage(){
    echo "
Creates a new Service Connection on Azure DevOps to connect to a Kubernetes Cluster

See more at: $(printInfo https://github.com/psbds/kubernetes-snippets/tree/master/devops)

Commands: 

    create-service-connection                       Creates a Service Connection for Azure DevOps.
"
    exit
}

case $1 in
    create-service-connection)  shift && load "devops/create-service-connection/index.bash" $@ ;;
    *) usage ;;
esac