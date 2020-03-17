
usage(){
    echo "
Creates a new Service Connection on Azure DevOps to connect to a Kubernetes Cluster

See more at: $(printInfo https://github.com/psbds/kubernetes-snippets/tree/master/devops)

Examples: 

    # Create the Service Connection on Azure DevOps
    akssnipets devops create-service-connection -o contosoOrganization -p constosoProject -pat patToken -u user

Arguments:
    -o,     --organization           [Required]   : The Azure DevOps organization where the service connection will be created.    
    -p,     --project                [Required]   : The Azure DevOps project where the service connection will be bound. 
    -pat,   --personal-access-token  [Required]   : The Personal Access Token of an user with access to create service connection.
    -u,     --user                   [Required]   : The email of the user owner of the PAT token.   
    -h,     --help                                : Show this message and exit.
    -v,     --verbose                             : Increase logging verbosity.
"
}