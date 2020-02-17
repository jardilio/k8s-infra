resource "null_resource" "kubeconfig" {
    triggers = {
        # always trigger this to run and set our kubernetes context
        timestamp = "${timestamp()}"
    }
    provisioner "local-exec" {
        command = "${var.kubeinit} && kubectl config current-context > .kubecontext"
    }
}

data "local_file" "kubecontext" {
    depends_on = ["null_resource.kubeconfig"]
    filename = ".kubecontext"
}