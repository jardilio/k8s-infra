module "infra" {
    source = "../../modules/infra/local"
    context = "docker-desktop"
}

module "platform" {
    source = "../../modules/platform"
    kubeinit = "${module.infra.kubeinit}"
}

module "stack" {
    source = "../../modules/stacks/example"
    kubecontext = "${module.platform.kubecontext}"
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