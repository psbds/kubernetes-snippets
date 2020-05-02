# Kubernetes Snippets

Hello World!


This repository contains some scripts that I share with Microsoft partners thare are starting to work with AKS (and kubernetes in general).

Feel free to create an issue or PR to contribute, and why not have a chat on [LinkedIn](https://www.linkedin.com/in/paulobaima/) 🙂


## CLI

[Running Scripts from this Repository](./.devcontainer/README.md)

For the sake of be easier to use, I've create a simple CLI wrapping the commands from azure-cli, kubectl, istioctl and veleroctl.

There's also a autocomplete feature to make easier to use, if you're on Linux, just add this line to your .bashrc

```source path/to/project/cli/autocomplete.bash```

### Available Commands

* ```cluster``` - [Cluster Management Utilities](./cli/cluster)
    * ```create``` - [Create an AKS Cluster](./cli/cluster/create)
    * ```create-aad-credentials``` - [Creates the credentials for AAD Integration](./cli/cluster/create-aad-credentials)

* ```devops``` - [DevOps Utilities](./cli/devops)
    * ```create-service-connection``` - [Create Azure DevOps Service Connection](./cli/devops/create-service-connection)

* ```backup``` - [Backup Utilities](./cli/backup)
    * ```create-velero-vault``` - [Create a new Velero Vault to store/retrieve backups](./cli/devops/create-service-connection)
    * ```install-velero``` - [Install velero crds on the cluster and configure the Velero Vault](./cli/devops/create-service-connection)
    * ```uninstall-velero``` - [ Remove all velero crds from the cluster](./cli/devops/create-service-connection)