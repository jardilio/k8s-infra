locals {
    istio_version = "1.3.1"
}

resource "kubernetes_namespace" "istio" {
  metadata {
    name = "istio-system"
  }
}

resource "helm_release" "istio_init" {
    repository = "https://storage.googleapis.com/istio-release/releases/${local.istio_version}/charts/"
    chart = "istio-init"
    name = "istio-init"
    namespace = "${kubernetes_namespace.istio.metadata.0.name}"
}

resource "null_resource" "istio_crds" {
    depends_on = ["helm_release.istio_init"]
    triggers = {
        istio_version = "${local.istio_version}"
    }
    provisioner "local-exec" {
        # need to wait for CRD's to finish loading from init before proceeding
        command = "sleep 60"
    }
}

resource "helm_release" "istio" {
    depends_on = ["null_resource.istio_crds"]
    repository = "https://storage.googleapis.com/istio-release/releases/${local.istio_version}/charts/"
    chart = "istio"
    name = "istio"
    namespace = "${kubernetes_namespace.istio.metadata.0.name}"

    # https://istio.io/docs/reference/config/installation-options/

    set {
        name = "gateways.enabled"
        value = "false"
    }

    set {
        name = "galley.enabled"
        value = "false"
    }

    set {
        name = "certmanager.enabled"
        value = "false"
    }

    set {
        name = "pilot.enabled"
        value = "false"
    }

    set {
        name = "gateways.istio-ingressgateway.type"
        value = "${var.default_service_type}"
    }

    set {
        name = "prometheus.enabled"
        value = "false"
    }

    set {
        name = "prometheus.service.nodePort.enabled"
        value = "false"
    }

    set {
        name = "security.enabled"
        value = "false"
    }

    set {
        name = "sidecarInjectorWebhook.enabled"
        value = "false"
    }

    set {
        name = "grafana.enabled"
        value = "false"
    }
}