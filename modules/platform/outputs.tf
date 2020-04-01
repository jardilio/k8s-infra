output "kubecontext" {
    description = "Context to use for kubectl that module has initialized"
    value = "${local.kubecontext}"
}