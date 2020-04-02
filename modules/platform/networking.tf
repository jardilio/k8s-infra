resource "template_dir" "networking" {
  source_dir = "${path.module}/networking"
  destination_dir = "${path.root}/.terraform/tmp/platform_networking_templates"

  vars = {
    # Place any variables here for interpolation in the template between clusters
  }
}

# TODO: reactivate TLS with istio-gateway

resource "null_resource" "networking" {
    depends_on = [
        "null_resource.istio",
        "template_dir.networking",
        "helm_release.dashboard"
    ]
    triggers = {
        template = "${template_dir.networking.id}"
    }
    provisioner "local-exec" {
        command = "kubectl apply -f ${template_dir.networking.destination_dir}"
    }
    provisioner "local-exec" {
        when = "destroy"
        on_failure = "continue"
        command = "kubectl delete -f ${template_dir.networking.destination_dir}"
    }
}