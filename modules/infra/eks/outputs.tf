output "kubeinit" {
    depends_on = [
        "module.cluster"
    ]
    value = "aws eks update-kubeconfig --name ${var.name} --region ${var.region}"
}