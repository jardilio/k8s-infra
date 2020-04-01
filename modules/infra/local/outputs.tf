output "kubeinit" {
    value = "kubectl config use-context ${var.context}"
}