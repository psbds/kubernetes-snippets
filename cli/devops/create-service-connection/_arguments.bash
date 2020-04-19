#/bin/bash
# Author: Paulo Baima
# Source: https://github.com/psbds/kubernetes-snippets

# Default Args
{
    VERBOSE=0
}

arguments=( 
    "-o|--organization:ORGANIZATION_NAME"
    "-p|--project:PROJECT_NAME"
    "-pat|--personal-access-token:PERSONAL_ACCESS_TOKEN"
    "-u|--user:USER"
    "-h|--help:create-service-connection"
    "-v|--verbose" )

# Source: cli/helpers.bash
read_args arguments $@

validate_args(){
    VALID=1
    validate_empty "$ORGANIZATION_NAME"         "Argument -o, --organization is required.\n"
    validate_empty "$PROJECT_NAME"              "Argument -p, --project is required.\n"
    validate_empty "$PERSONAL_ACCESS_TOKEN"     "Argument -pat, --personal-access-token is required.\n"
    validate_empty "$USER"                      "Argument -u, --user is required.\n"

    if [ $VALID == 0 ]; then exit 1; fi   
}

validate_args