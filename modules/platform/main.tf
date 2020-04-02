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

# force wait for istio to finish before we say we are ready
data "local_file" "kubecontext_istio" {
    depends_on = ["null_resource.istio"]
    filename = ".kubecontext"
}

locals {
    kubecontext = "${trimspace(data.local_file.kubecontext.content)}"
}