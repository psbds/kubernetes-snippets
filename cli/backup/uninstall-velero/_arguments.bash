#/bin/bash
# Author: Paulo Baima
# Source: https://github.com/psbds/kubernetes-snippets

arguments=( 
    "-h|--help:uninstall-velero"
    "-v|--verbose" )

# Source: cli/helpers.bash
read_args arguments $@