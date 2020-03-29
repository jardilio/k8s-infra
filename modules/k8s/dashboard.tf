resource "kubernetes_namespace" "kubernetes_dashboard" {
  metadata {
    name = "kubernetes-dashboard"
  }
}

resource "helm_release" "dashboard" {
    depends_on = ["helm_release.istio"]
    chart = "stable/kubernetes-dashboard"
    name = "kubernetes-dashboard"
    namespace = "${kubernetes_namespace.kubernetes_dashboard.metadata.0.name}"
    version = "1.10.0"

    # https://github.com/helm/charts/tree/master/stable/kubernetes-dashboard

    set {
      name = "enableSkipLogin"
      value = "true"
    }

    set {
      name = "ingress.enabled"
      value = "true"
    }
}