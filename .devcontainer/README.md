# Running the Scripts from this Repository

There are two easy  ways to run the scripts from this repo.

## Using GitPod

GitPod is an awesome website which provides you a free container a editor in your browser

I've configured a custom docker image do run the scripts from this help, you can open this repository with GitPod in the link below.

[![Gitpod Ready-to-Code](https://img.shields.io/badge/Gitpod-Ready--to--Code-blue?logo=gitpod)](https://gitpod.io/#https://github.com/psbds/kubernetes-snippets) 


## Using VSCode and the Remote Containers Extension (BEST EXTENSION EVER)

## Requirements
<img src="https://github.com/psbds/kubernetes-snippets/raw/master/doc-images/docker.png" height="100px" /> <img src="https://github.com/psbds/kubernetes-snippets/raw/master/doc-images/vscode.png" height="100px" />

* Docker Installed and Running (and set to use Linux Containers)
  * Install Docker on Windows (https://docs.docker.com/docker-for-windows/install/)
  * Install Docker on MAC (https://docs.docker.com/docker-for-mac/install/)
  * Install Docker on Ubuntu or other Linux distributions (https://docs.docker.com/install/linux/docker-ce/ubuntu/)
  
* Latest edition of VSCode
    * Download VSCode Here (https://code.visualstudio.com/)

## How to Run It
1. First of all clone or donwload this repository.

    ```git clone https://github.com/psbds/kubernetes-snippets.git```

2. Open VSCode and go to File > Open Folder and open the project folder.

3. Install the VSCode Remote Containers Extension: https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers

4. Now, Open the command palette (ctrl+shift+p on windows) and select the option 'Remote-Containers: Reopen in container".

What will happen is that VSCode will use the config files on the .devcontainer folder to create a container and run VSCode server inside it. 

So with a shared docker volume, you will be able to continue using the VSCode IDE, but running all the scripts/applications inside the container. 

You can find the full explanation of how it works right here: https://code.visualstudio.com/docs/remote/containers

You can use the same extension to run apps on nodejs, python, or literally anything that can run on a container, this helps a lot on not having to setup your machine or a machine of a new developer on the team.

Just Docker + VSCode + Remote Containers Extension and you're ready to go.

## Container Image

This project uses a container image based on the default Azure CLI image that comes with the remote containers extension.

I've also added the command lines for kubectl, helm, istio and velero inside it and create a custom image that you can find right here: https://hub.docker.com/r/psbds/dev-container-aks

And the Dockerfile for the custom image, right here: https://github.com/psbds/dev-containers/blob/master/aks-dev-container/.devcontainer/Dockerfile
