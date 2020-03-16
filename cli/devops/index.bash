#/bin/bash

usage(){
    echo '
Kubernetes Snippets for DevOps. See more at: https://github.com/psbds/kubernetes-snippets/tree/master/devops

    Commands: 

        create-service-connection                       Creates a Service Connection for Azure DevOps.
    '
    exit
}

case $1 in
    create-service-connection)  shift && load "devops/create-service-connection/index.bash" $@ ;;
    *) usage ;;
esac