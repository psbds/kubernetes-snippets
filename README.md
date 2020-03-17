# Kubernetes Snippets

Hello World!


This repository contains some scripts that I share with Microsoft partners thare are starting to work with AKS (and kubernetes in general).

Feel free to create an issue or PR to contribute, and why not have a chat on [LinkedIn](https://www.linkedin.com/in/paulobaima/) 🙂
## Summary

* [Running Scripts from this Repository](https://github.com/psbds/kubernetes-snippets/blob/master/.devcontainer/README.md)
* [Kubernetes Permissions](https://github.com/psbds/kubernetes-snippets/tree/master/kubernetes-permissions)
* [Kubernetes Backup & Migration with Velero](https://github.com/psbds/kubernetes-snippets/tree/master/backup)
* Azure DevOps
    * [Setting Up Service Connections for Kubernetes](https://github.com/psbds/kubernetes-snippets/tree/master/devops/service-connection-setup)


## CLI

For the sake of be easier to use, I've create a simple CLI wrapping the commands from azure-cli, kubectl, istioctl and veleroctl.

There's also a autocomplete feature to make easier to use, if you're on Linux, just add this line to your .bashrc

```source path/to/project/cli/autocomplete.bash```

### Available Commands

* ```cluster``` - [Cluster Management Tools](https://github.com/psbds/kubernetes-snippets/tree/master/cli/cluster)
    * ```create``` - [Create an AKS Cluster](https://github.com/psbds/kubernetes-snippets/tree/master/cli/cluster/create)
    
* ```devops``` - [DevOps Utilities](https://github.com/psbds/kubernetes-snippets/tree/master/cli/devops)
    * ```create-service-connection``` - [Create Azure DevOps Service Connection](https://github.com/psbds/kubernetes-snippets/tree/master/cli/devops/create-service-connection)


## Coming soon

* Istio Setup
* Kured Setup
* WeaveScope Setup
* Azure DevOps Pipelines Templates
* Terraform Templates
