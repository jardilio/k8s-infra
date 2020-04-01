Designed to work with local clusters installed and running 
on the host for testing purposes. Requires you already have
kubernetes running on the host, you can enable with 
docker or minikube.

This can also be used for any other cluster not created and 
managed by this terraform project, if all you want to do is
manage the deployment of applications and configurations to 
that cluster. Just make sure your local kubeconfig is setup 
and provide the context name of the target cluster.

Be sure to set enough CPU and memory to docker, see https://istio.io/docs/setup/platform-setup/docker/

* [inputs](./variables.tf)
* [outputs](./outputs.tf)