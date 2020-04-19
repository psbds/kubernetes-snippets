## Kubernetes Snippets CLI (devops/create-service-connection)

Creates a new Service Connection on Azure DevOps to connect to a Kubernetes Cluster.


This script creates a ClusteRole and ClsuteRoleBinding with full permissions on the cluster so Azure DevOps can do the deployment of anything, you can refine to have a more granular and secure set of permission, editing the file `cli/devops/create-serviceconnection/index.bash`


### Usage

```
akssnippets devops create-service-account -o contosoOrganization -p constosoProject -pat patToken -u user
```

### Arguments

| Arguments 	                | Type 	    | Default 	| Required 	| Description 	|
|-----------	                |------	    |---------	|--------	|-------------	|
| -o, --organization            | string    | empty     | yes       | The Azure DevOps organization where the service connection will be created.            	|
| -p, --project                 | string    | empty     | yes       | The Azure DevOps project where the service connection will be bound.                      |
| -pat, --personal-access-token | string    | empty     | yes       | The Personal Access Token of an user with access to create service connection.            |
| -u, --user                    | string    | empty     | yes       | The email of the user owner of the PAT token.                                             |
| -v, --verbose                 |           |           |           | Increase logging verbosity.                                                               |
| -h, --help                    |           |           | no        | Show help message.                                                                        |