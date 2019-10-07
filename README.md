An accelerator for working with kubernetes on various cloud platforms with terraform.

# Platforms

* [local](./modules/local) - Run on a local kubernetes cluster, usually for local development with docker desktop
* [eks](./modules/eks) - Create and manage a remote EKS cluster on Amazon Web Services
* [gke](./modules/gke) - Create and manage a remote GKE cluster on Google Cloud Platform
* [aks](./modules/aks) - Create and manage a remote AKS cluster on Azure

# Getting Started

* Install Docker - https://docs.docker.com/docker-for-mac/install/
* Start the container - `docker-compose run --rm console`
* Select the target environment when prompted (select `none` to just get the CLI tools without targeting)
* Check the readme for your target `platform` to initialize your machine the first time
* Customize your installation via the terraform files
* Run a plan of your changes