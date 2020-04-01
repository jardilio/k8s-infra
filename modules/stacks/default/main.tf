
module "hello_world" {
    source = "../../apps/generic-web"
    namespace = "default"
    app_name = "hello-world"
    app_image = "nginxdemos/hello"
    app_version = "latest"
    min_instances = 1
    max_instances = 3
}