# NOTE: Istio is moving away from helm and instead leveraging istioctl directly which is why we aren't using helm here

locals {
  istio_version = "1.5.1"
}


# use the namespace for clean-up on destroy
resource "kubernetes_namespace" "istio" {
  metadata {
    name = "istio-system"
  }
}

data "template_file" "istio" {
  # generated with: `istioctl profile dump demo > istio.yaml`
  # remove everything after "components" block or may get errors
  template = "${file("${path.module}/istio.yaml")}"
  vars = {
    # Place vars here to interpolate template
  }
}

resource "null_resource" "istio" {
    depends_on = [
        "data.template_file.istio",
        "data.local_file.kubecontext",
        "kubernetes_namespace.istio"
    ]

    triggers = {
        template = "${data.template_file.istio.rendered}"
        istio_version = "${local.istio_version}"
    }

    # install correct version requested
    provisioner "local-exec" {
        command = "cd /tmp && curl -L https://istio.io/downloadIstio | ISTIO_VERSION=${local.istio_version} sh -"
    }
    provisioner "local-exec" {
        command = "cp --force /tmp/istio-${local.istio_version}/bin/istioctl /usr/local/bin/"
    }

    # generate the ops file template
    provisioner "local-exec" {
        environment = {
            TEMPLATE = "${data.template_file.istio.rendered}"
        }
        command = "echo \"$TEMPLATE\" > ${path.module}/istio.yaml.generated"
    }

    # apply the changes to the cluster
    provisioner "local-exec" {
        command = "istioctl --verbose --context=${trimspace(data.local_file.kubecontext.content)} manifest apply -f ${path.module}/istio.yaml.generated --wait"
    }
}