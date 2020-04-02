An accelerator for working with kubernetes on various cloud platforms with terraform. Will provision a cluster (optional) and 
then populate the cluster with common tools and services, including:

* [Helm](https://helm.sh/) - Package manager for installing and configuring kubernetes packages
* [Kubernetes-Dashboard](https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/) - Front-end GUI for managing your cluster
* [Istio](https://istio.io/) - Service mesh for your cluster

This project makes use of a local docker image which contains all the required CLI tools to work with this project and 
a custom entry point to initialize the CLI tools for your target environment. 

# Clusters

Create additional clusters in the `cluster` directory, this is just a main entry point for your terraform
that will link to the appropriate terraform modules. Examples were included for each provider, including:

* [docker-desktop](./clusters/docker-desktop_example) - Run on a local kubernetes cluster, usually for local development with docker desktop
* [eks](./clusters/eks_example) - Create and manage a remote EKS cluster on Amazon Web Services
* [gke](./clusters/gke_example) - Create and manage a remote GKE cluster on Google Cloud Platform
* [aks](./clusters/aks_example) - Create and manage a remote AKS cluster on Azure

# Getting Started

* Install Docker - https://docs.docker.com/docker-for-mac/install/
* Set your local environment variables - you can store these in `.env`
    * CLUSTER - (optional) The name of the cluster directory to target (ie `docker-desktop_example`)
    * GOOGLE_APPLICATION_CREDENTIALS - (required if using GCP) See [here](./modules/infra/gke)
    * AWS_PROFILE - (required if using AWS) See [here](./modules/infra/eks)
    * ASM_SUBSCRIPTION_ID - (required if using Azure) See [here](./modules/infra/aks)
* Start the console - `docker-compose run --rm console`
* Select your cluster - Optional if you set environment variable `CLUSTER`
* Deploy your cluster - `terraform apply -auto-approve`
* Get the address of your ingress gateways:
    * Dashboard - `DASHBOARD_GATEWAY=$(kubectl get service kubernetes-dashboard -n kube-system -o jsonpath='{.status.loadBalancer.ingress[0].*}'`
    * Istio - `ISTIO_GATEWAY=$(kubectl get service istio-ingressgateway -n istio-system -o jsonpath='{.status.loadBalancer.ingress[0].*}')`

By default, the following services should be available:

* [Kubernetes Dashboard](https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/): `http://$DASHBOARD_GATEWAY:8080`
* [Kiali](https://kiali.io/): `http://$ISTIO_GATEWAY:15029`
* [Prometheus](https://prometheus.io/): `http://$ISTIO_GATEWAY:15030`
* [Grafana](https://grafana.com/): `http://$ISTIO_GATEWAY:15031`

From there you can modify the source terraform files and run a new apply. Or create new environments and deploy new clusters there.

Additional docker-compose services are created for automation, including:

* `docker-compose run --rm console` - Initialize the cluster and all the CLI tools and provide the user a console for manual input
* `docker-compose run --rm plan` - Run a terraform plan of the changes for the current cluster and output a plan file
* `docker-compose run --rm destroy` - Run a terraform plan to destroy current cluster and output a plan file
* `docker-compose run --rm apply` - Run a terraform apply from the above plan or destroy

# Status

## Infra

* [local](./modules/infra/local) - Support for local kubectl access to local or remote cluster working, tested with Docker-Desktop running Kubernetes 1.15.
* [gke](./modules/infra/gke) - Initial support for provisining simple cluster and worker nodes is complete. Pending more structured networking constraints and isolation setmentation.
* [eks](./modules/infra/eks) - WIP - Code is started, not complete or tested.
* [aks](./clmodules/infrausters/aks) - Not Started

## Platform

* [Helm](./modules/platform/helm.tf): Working and configurable
* [Kubernetes Dashboard](./modules/platform/dashboard.tf): Working and configurable, needs to be secured
* [Istio](./modules/platform/istio.tf): Working and configurable, add-on components need to be secured

## Stacks/Apps

WIP - This is just setting up some example stacks of applications that can be deployed to the cluster. A "stack" is just a composition of a set of applications that are configured as a whole. The same "stack" may be deployed to several different environments which slightly different configurations (ie versions of app services or scaling of those services). 