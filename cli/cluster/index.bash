#/bin/bash
# Author: Paulo Baima
# Source: https://github.com/psbds/kubernetes-snippets
set -e

usage(){
    echo "
Kubernetes Snippets for Cluster Management. 

See more at: $(printInfo https://github.com/psbds/kubernetes-snippets/tree/master/cluster)

Commands: 

    create                       Creates a AKS Cluster on Azure.
"
    exit
}

case $1 in
    create)  shift && load "cluster/create/index.bash" $@ ;;
    *) usage ;;
esac