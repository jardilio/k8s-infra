# NOTE: Istio is moving away from helm and instead leveraging istioctl directly which is why we aren't using helm here. Also doesn't support helm 3.x.

locals {
  istio_version = "1.5.1"
  istio_bookinfo_enabled = 0
}

data "template_file" "istio_ops" {
  # generated with: `istioctl profile dump demo > istio.yaml`
  template = "${file("${path.module}/istio_ops.yaml")}"
  vars = {
    # Place any variables here for interpolation in the template between clusters
  }
}

resource "null_resource" "istio_cleanup" {
    # run the destroy separately from null_resource.istio...otherwise terraform runs destroy on trigger changes in null_resource.istio

    depends_on = [
        "data.template_file.istio_ops",
        "data.local_file.kubecontext"
    ]

    # delete all the resources
    provisioner "local-exec" {
        when = "destroy"
        on_failure = "continue"
        environment = {
            TEMPLATE = "${data.template_file.istio_ops.rendered}"
            CONTEXT = "${local.kubecontext}"
        }
        command = <<EOT
            MANIFEST=$(echo "$TEMPLATE" | istioctl --context=$CONTEXT manifest generate -f -)
            echo "$MANIFEST" | kubectl delete --ignore-not-found -f -
        EOT
    }
    
    # force cleanup on cluster just in case above had any errors
    provisioner "local-exec" {
        when = "destroy"
        on_failure = "continue"
        command = "kubectl delete namespace istio-system --ignore-not-found --wait --force"
    }
}

resource "null_resource" "istio" {
    depends_on = [
        "data.template_file.istio_ops",
        "data.local_file.kubecontext",
        "null_resource.istio_cleanup"
    ]

    triggers = {
        template = "${data.template_file.istio_ops.rendered}"
        istio_version = "${local.istio_version}"
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

    # TODO: Handle upgrade/downgrade of istio version

    # apply the changes to the cluster
    provisioner "local-exec" {
        environment = {
            TEMPLATE = "${data.template_file.istio_ops.rendered}"
            CONTEXT = "${local.kubecontext}"
        }
        command = "echo \"$TEMPLATE\" | istioctl --context=$CONTEXT manifest apply -f -"
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
    }

    provisioner "local-exec" {
        command = "curl https://raw.githubusercontent.com/istio/istio/${local.istio_version}/samples/bookinfo/platform/kube/bookinfo.yaml | kubectl apply -f -"
    }
    provisioner "local-exec" {
        when = "destroy"
        on_failure = "continue"
        command = "curl https://raw.githubusercontent.com/istio/istio/${local.istio_version}/samples/bookinfo/platform/kube/bookinfo.yaml | kubectl delete -f -"
    }

    provisioner "local-exec" {
        command = "curl https://raw.githubusercontent.com/istio/istio/${local.istio_version}/samples/bookinfo/networking/bookinfo-gateway.yaml | kubectl apply -f -"
    }
    provisioner "local-exec" {
        when = "destroy"
        on_failure = "continue"
        command = "curl https://raw.githubusercontent.com/istio/istio/${local.istio_version}/samples/bookinfo/networking/bookinfo-gateway.yaml | kubectl delete -f -"
    }
}