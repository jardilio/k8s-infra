output "kubecontext" {
    depends_on = ["null_resource.istio"]
    description = "Context to use for kubectl that module has initialized"
    value = "${trimspace(data.local_file.kubecontext_istio.content)}"
}