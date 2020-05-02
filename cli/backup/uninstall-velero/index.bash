#/bin/bash
# Authors: Paulo Baima & Vinicius Batista
# Source: https://github.com/psbds/kubernetes-snippets
DIR="${BASH_SOURCE%/*}" ; if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi

source $DIR/_arguments.bash

kubectl delete namespace/velero clusterrolebinding/velero
kubectl delete crds -l component=velero