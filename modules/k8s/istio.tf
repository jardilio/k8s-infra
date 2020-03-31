# NOTE: Istio is moving away from helm and instead leveraging istioctl directly which is why we aren't using helm here

locals {
  istio_version = "1.5.1"
  istio_bookinfo_enabled = 1
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
    default_service_type = "${var.default_service_type}"
    # FIXME: fails to load testing in docker-desktop
    sidecar_injection_enabled = "false"
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
        foo = "bar"
    }

    # make sure default namespace is labeled for injection
    provisioner "local-exec" {
        command = "kubectl label --overwrite namespace default istio-injection=enabled"
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
        command = "echo \"$TEMPLATE\" > istio.yaml.generated"
    }
    provisioner "local-exec" {
        when = "destroy"
        environment = {
            TEMPLATE = "${data.template_file.istio.rendered}"
        }
        command = "echo \"$TEMPLATE\" > istio.yaml.generated"
    }

    # apply the changes to the cluster
    provisioner "local-exec" {
        command = "istioctl --verbose --context=${trimspace(data.local_file.kubecontext.content)} manifest apply --wait -f istio.yaml.generated"
    }
    provisioner "local-exec" {
        when = "destroy"
        on_failure = "continue"
        command = "istioctl --verbose --context=${trimspace(data.local_file.kubecontext.content)} manifest generate -f istio.yaml.generated | kubectl delete -f -"
    }
}

# deploy the sample bookinfo for testing
resource "null_resource" "istio_bookinfo" {
    count = "${local.istio_bookinfo_enabled}"

    depends_on = [
        "null_resource.istio"
    ]

    triggers = {
        istio_version = "${local.istio_version}"
        foo = "bar"
    }

    provisioner "local-exec" {
        command = "curl -Lo bookinfo.yaml.generated https://raw.githubusercontent.com/istio/istio/${local.istio_version}/samples/bookinfo/platform/kube/bookinfo.yaml && istioctl kube-inject -f bookinfo.yaml.generated | kubectl apply -f -"
    }
    provisioner "local-exec" {
        when = "destroy"
        on_failure = "continue"
        command = "curl -Lo bookinfo.yaml.generated https://raw.githubusercontent.com/istio/istio/${local.istio_version}/samples/bookinfo/platform/kube/bookinfo.yaml && istioctl kube-inject -f bookinfo.yaml.generated | kubectl delete -f -"
    }
}