resource "kubernetes_namespace" "kubernetes_dashboard" {
  depends_on = ["null_resource.istio"]
  metadata {
    name = "kubernetes-dashboard"
    labels = {
        istio-injection = "enabled"
    }
  }
}

resource "helm_release" "dashboard" {
    repository = "${local.helm_stable}"
    chart = "stable/kubernetes-dashboard"
    name = "kubernetes-dashboard"
    namespace = "${kubernetes_namespace.kubernetes_dashboard.metadata.0.name}"
    version = "1.10.0"

    # https://github.com/helm/charts/tree/master/stable/kubernetes-dashboard

    set {
      name = "enableSkipLogin"
      value = "true"
    }

    # TODO: reactivate TLS with istio-gateway

    set {
      name = "service.internalPort"
      value = "8080"
    }

    set {
      name = "service.externalPort"
      value = "8080"
    }

    set {
      name = "enableInsecureLogin"
      value = "true"
    }
}