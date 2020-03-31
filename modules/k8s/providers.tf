terraform {
    required_version = "< 0.13"
    # TODO: select your terraform state backend management platform
    backend "local" {}
    # backend "atlas" {}
    # backend "gcs" {}
}

provider "null" {
    version = "~> 2.1"
}

provider "local" {
    version = "~> 1.4"
}

provider "template" {
    version = "~> 2.1"
}

provider "kubernetes" {
    version = "~> 1.11"
    load_config_file = true
    config_context = "${trimspace(data.local_file.kubecontext.content)}"
}

provider "helm" {
    # version 1+ using Helm 3, istio requires 2.x
    version = "~> 1.1"
    # version = "0.10.4"
    # install_tiller = true
    kubernetes {
        load_config_file = true
        config_context = "${trimspace(data.local_file.kubecontext.content)}"
    }
}