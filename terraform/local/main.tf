module "k8s" {
    source = "../k8s"
    kubeinit = "kubectl config use-context ${var.context}"
    default_service_type = "NodePort"
}