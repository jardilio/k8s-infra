module "infra" {
    source = "../../modules/infra/gke"
    project = "devops-demo-216801"
    name = "gke-example"
    region = "us-central1"
    kubernetes_version = "1.15.9"
    zones = [
        "us-central1-a",
        "us-central1-b",
        "us-central1-c"
    ]
}

module "platform" {
    source = "../../modules/platform"
    kubeinit = "${module.infra.kubeinit}"
}

# this is an example of loading the same "stack" for different environments with different namespaces and app versions

module "dev-stack" {
    depend_on = [module.platform.kubecontext]
    source = "../../modules/stacks/example"
    namespace = "dev"
    app_version = "1.17.9"
}

module "qa-stack" {
    depend_on = [module.platform.kubecontext]
    source = "../../modules/stacks/example"
    namespace = "qa"
    app_version = "1.16.1"
}

module "uat-stack" {
    depend_on = [module.platform.kubecontext]
    source = "../../modules/stacks/example"
    namespace = "uat"
    app_version = "1.15.12"
}