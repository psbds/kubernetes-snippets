set -e

usage(){
    echo "
DevOps utilities for Kubernetes.

See more at: $(printInfo https://github.com/psbds/kubernetes-snippets)

Commands: 

    cluster     Kubernetes Snippets for Cluster Management.
    devops      DevOps utilities for Kubernetes.
    backup      Backp utilities for Kubernetes.

Arguments:

    -h, --help      : Show this message and exit.
"
    
}