#/bin/bash
# Author: Paulo Baima
# Source: https://github.com/psbds/kubernetes-snippets
set -e

usage(){
    echo 'Creates a new Service Connection on Azure DevOps to connect to a Kubernetes Cluster

    Examples: 

        # Create the Service Connection on Azure DevOps
        ./akssnipets.sh devops create-service-connection -o contosoOrganization -p constosoProject -pat patToken -u user

    Arguments:
        -o,     --organization           [Required]     The Azure DevOps organization where the service connection will be created.    
        -p,     --project                [Required]     The Azure DevOps project where the service connection will be bound. 
        -pat,   --personal-access-token  [Required]     The Personal Access Token of an user with access to create service connection.
        -u,     --user                   [Required]     The email of the user owner of the PAT token.   
        -h,     --help                                  Show this message and exit.
        -v,     --verbose                               Increase logging verbosity
    '
    exit
}

VERBOSE=0

while [ "$1" != "" ]; do
    case $1 in
        -o | --organization )               shift && ORGANIZATION_NAME=$1
                                            ;;
        -p | --project )                    shift && PROJECT_NAME=$1
                                            ;;
        -pat | --personal-access-token )    shift && PERSONAL_ACCESS_TOKEN=$1
                                            ;;
        -u | --user )                       shift && USER=$1
                                            ;;
        -h | --help )                       usage
                                            ;;
        -v | --verbose )                    VERBOSE=1
                                            ;;
    esac
    shift
done

validate_args(){
    if [ -z "$ORGANIZATION_NAME" ]
    then
        printDanger "Argument -o, --organization is required.\n"
        exit 1;
    fi

    if [ -z "$PROJECT_NAME" ]
    then
        printDanger "Argument -p, --project is required.\n"
        exit 1;
    fi

    if [ -z "$PERSONAL_ACCESS_TOKEN" ]
    then
        printDanger "Argument -pat, --personal-access-token is required.\n"
        exit 1;
    fi

    if [ -z "$USER" ]
    then
        printDanger "Argument -u, --user is required.\n"
        exit 1;
    fi
}

validate_args