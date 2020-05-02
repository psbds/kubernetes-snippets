#/bin/bash
# Author: Paulo Baima
# Source: https://github.com/psbds/kubernetes-snippets

# Default Args
{
    VERBOSE=0
}

arguments=( 
    "-n|--name:SP_NAME"
    "-h|--help:create-aad-credentials"
    "-v|--verbose" )

# Source: cli/helpers.bash
read_args arguments $@

validate_args(){
    VALID=1
    validate_empty "$SP_NAME"              "Argument -n, --name is required.\n"

    if [ $VALID == 0 ]; then exit 1; fi
}

validate_args