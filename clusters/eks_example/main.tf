module "infra" {
    source = "../../modules/infra/eks"
    name = "eks-example"
    region = "us-west-2"
    kubernetes_version = "1.15"
    zones = [
        "us-west-2a",
        "us-west-2b",
        "us-west-2c"
    ]
    tags = {
        Project = "SGI Cloud Reference Architecture"
        Owner = "Jeff Ardilio"
        Chargecode = "3000249559"
    } 
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