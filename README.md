An accelerator for working with kubernetes on various cloud platforms with terraform. Will provision a cluster (optional) and 
then populate the cluster with common tools and applications, including:

* [Helm](https://helm.sh/) - Package manager for installing and configuring kubernetes packages
* [Kubernetes-Dashboard](https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/) - Front-end GUI for managing your cluster
* [Istio](https://istio.io/) - Service mesh for your cluster

This project makes use of a local docker image which contains all the required CLI tools to work with this project and 
a custom entry point to initialize the CLI tools for your target environment. 

# Environments

Create additional environments in the `environments` directory, this is just a main entry point for your terraform
that will link to the appropriate terraform modules. Examples were included for each platform, including:

* [docker-desktop](./environments/docker-desktop_example) - Run on a local kubernetes cluster, usually for local development with docker desktop
* [eks](./environments/eks_example) - Create and manage a remote EKS cluster on Amazon Web Services
* [gke](./environments/gke_example) - Create and manage a remote GKE cluster on Google Cloud Platform
* [aks](./environments/aks_example) - Create and manage a remote AKS cluster on Azure

# Getting Started

* Install Docker - https://docs.docker.com/docker-for-mac/install/
* Check the readme for your target `environment` to initialize your machine the first time
* Start the container - `docker-compose run --rm console`
* Select the target environment when prompted (select `none` to just get the CLI tools without targeting)
* Run `terraform apply` to deploy the default configurations

From there you can modify the source terraform files and run a new apply. 

# Debugging your services

Use the `kubectl` to list all services in all namespaces:

```
kubectl get services --all-namespaces

NAMESPACE              NAME                   TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)                                  AGE
default                kubernetes             ClusterIP   10.96.0.1        <none>        443/TCP                                  48m
docker                 compose-api            ClusterIP   10.110.132.97    <none>        443/TCP                                  47m
istio-system           grafana                ClusterIP   10.107.120.203   <none>        3000/TCP                                 3m28s
istio-system           istio-policy           ClusterIP   10.96.210.110    <none>        9091/TCP,15004/TCP,15014/TCP             4m40s
istio-system           istio-telemetry        ClusterIP   10.99.129.127    <none>        9091/TCP,15004/TCP,15014/TCP,42422/TCP   4m40s
istio-system           prometheus             ClusterIP   10.97.91.177     <none>        9090/TCP                                 108s
kube-system            kube-dns               ClusterIP   10.96.0.10       <none>        53/UDP,53/TCP,9153/TCP                   48m
kube-system            tiller-deploy          ClusterIP   10.100.196.166   <none>        44134/TCP                                2m5s
kubernetes-dashboard   kubernetes-dashboard   ClusterIP   10.106.245.131   <none>        443/TCP                                  6m42s
```

Then you can use the built-in proxy to expose those services on your host:

```
kubectl proxy

Starting to serve on 127.0.0.1:8001
```

Now you can load your cluster resources from your host via the proxy http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:443/proxy/