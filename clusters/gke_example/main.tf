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

module "stack" {
    source = "../../modules/stacks/example"
    kubecontext = "${module.platform.kubecontext}"
}