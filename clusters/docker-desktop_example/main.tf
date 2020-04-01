module "infra" {
    source = "../../modules/infra/local"
    context = "docker-desktop"
}

module "platform" {
    source = "../../modules/platform"
    kubeinit = "${module.infra.kubeinit}"
}