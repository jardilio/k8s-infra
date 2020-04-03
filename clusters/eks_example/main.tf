module "infra" {
    source = "../../modules/infra/eks"
    name = "eks-example"
    region = "us-east-1"
    kubernetes_version = "1.15"
    zones = [
        "us-east-1a",
        "us-east-1b",
        "us-east-1c"
    ]
}

module "platform" {
    source = "../../modules/platform"
    kubeinit = "${module.infra.kubeinit}"
}

# module "stack" {
#     source = "../../modules/stacks/example"
#     kubecontext = "${module.platform.kubecontext}"
# }