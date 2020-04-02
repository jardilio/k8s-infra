An accelerator for working with kubernetes on various cloud platforms with terraform. Will provision a cluster (optional) and 
then populate the cluster with common tools and applications, including:

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
    * CLUSTER - The name of the cluster directory to target (ie `docker-desktop_example`)
    * GOOGLE_APPLICATION_CREDENTIALS - (if using GCP) See [here](./modules/infra/gke)
    * AWS_PROFILE - (if using AWS) See [here](./modules/infra/eks)
    * ASM_SUBSCRIPTION_ID - (if using Azure) See [here](./modules/infra/aks)
* Start the console - `docker-compose run --rm console`
* Select your cluster - Optional if you set environment variable `CLUSTER`
* Deploy your cluster - `terraform apply -auto-approve`
* Get the address of your gateway - `GATEWAY=http://$(kubectl get service istio-ingressgateway -n istio-system -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')`

By default, the following services should be available:

* [Kubernetes Dashboard](https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/): `$GATEWAY:15028`
* [Kiali](https://kiali.io/): `$GATEWAY:15029`
* [Prometheus](https://prometheus.io/): `$GATEWAY:15030`
* [Grafana](https://grafana.com/): `$GATEWAY:15031`

From there you can modify the source terraform files and run a new apply. 

Additional docker-compose services are created for automation, including:

* `docker-compose run --rm console` - Initialize the cluster and all the CLI tools and provide the user a console for manual input
* `docker-compose run --rm plan` - Run a terraform plan of the changes for the current cluster and output a plan file
* `docker-compose run --rm destroy` - Run a terraform plan to destroy current cluster and output a plan file
* `docker-compose run --rm apply` - Run a terraform apply from the above plan or destroy