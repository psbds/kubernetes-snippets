## Kubernetes Snippets CLI (cluster/create-aad-credentials)

Creates the credentials on Azure Active Directory to integrate AKS with AAD Authentication.

### Usage

```
# Creates the credentials on Azure Active Directory to integrate AKS with AAD Authentication 
akssnippets cluster create-aad-credentials -n credentialname
```

### Arguments

| Arguments 	        | Type  	| Default                   | Required  | Description 	|
|-----------	        |------ 	|---------                  |--------   |-------------	|
| -n, --name            | string	| empty                     | yes       | Name the Service Principal that will be created.|

<br/>

| Additional Arguments  | Type 		| Default  | Required	| Description 	|
|-----------	      	|------		|--------- |-------- 	|-------------	|
| -v, --verbose       	|      		|          | no      	| Increase logging verbosity.|
| -h, --help          	|      		|          | no      	| Show help message.|