# Kubernetes Snippets

Hello World!


This repository contains some scripts that I share with Microsoft partners thare are starting to work with AKS (and kubernetes in general).

Feel free to create an issue or PR to contribute, and why not have a chat on [LinkedIn](https://www.linkedin.com/in/paulobaima/) 🙂


## Running the Scripts for this Repository

The easist way to run the scripts from this repo is using VSCode and the Remote Containers Extension (BEST EXTENSION EVER)

### Requirements
* Docker Installed and Running (and set to use Linux Containers)
    * Install Docker on Windows (https://docs.docker.com/docker-for-windows/install/)
    * Install Docker on MAC (https://docs.docker.com/docker-for-mac/install/)
    * Install Docker on Ubuntu or other Linux distributions (https://docs.docker.com/install/linux/docker-ce/ubuntu/)
* Latest edition of VSCode
    * Download VSCode Here (https://code.visualstudio.com/)

### How to Run It
1. First of all clone or donwload this repository this repository 

    ```git clone https://github.com/psbds/kubernetes-snippets.git```

2. Open VSCode and go to File > Open Folder and open the project folder

3. Install the VSCode Remote Containers Extension: https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers

4. Now, Open the command palette (ctrl+shift+p on windows) and select the option 'Remote-Containers: Reopen in container"

What will happen is that VSCode will use the config files on the .devcontainer folder to create a container and run VSCode server inside it. 

So with a shared docker volume, you will be able to continue using the VSCode IDE, but running all the scripts/applications inside the container. 

You can find the full explanation of how it works right here: https://code.visualstudio.com/docs/remote/containers

You can use the same extension to run apps on nodejs, python, or literally anything that can run on a container, this helps a lot on not having to setup your machine or a machine of a new developer on the team.

Just Docker + VSCode + Remote Containers Extension and you're ready to go.

### Container Image

This project uses a container image based on the default Azure CLI image that comes with the extension.

I've also added the command lines for kubectl, helm, istio and velero inside and create a custom image that you can find right here: https://hub.docker.com/r/psbds/dev-container-aks

And the Dockerfile for the custom image, right here: https://github.com/psbds/dev-containers/blob/master/aks-dev-container/.devcontainer/Dockerfile

## Summary

* [Cluster Creation Script](https://github.com/psbds/kubernetes-snippets/tree/master/create-cluster)
* [Kubernetes Permissions](https://github.com/psbds/kubernetes-snippets/tree/master/kubernetes-permissions)