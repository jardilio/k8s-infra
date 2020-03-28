resource "kubernetes_namespace" "dashboard" {
  metadata {
    name = "dashboard"
  }
}

resource "helm_release" "dashboard" {
    chart = "kubernetes-dashboard"
    name = "kubernetes-dashboard"
    version = "1.10.0"
    namespace = "${kubernetes_namespace.dashboard.metadata.0.name}"

    # https://github.com/helm/charts/tree/master/stable/kubernetes-dashboard

    set {
        name = "enableSkipLogin"
        value = "true"
    }
}