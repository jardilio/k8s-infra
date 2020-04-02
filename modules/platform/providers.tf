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
    config_context = "${local.kubecontext}"
}

provider "helm" {
    version = "~> 1.1"
    kubernetes {
        load_config_file = true
        config_context = "${local.kubecontext}"
    }
}