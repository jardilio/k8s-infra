resource "helm_release" "dashboard" {
    repository = "${local.helm_stable}"
    chart = "stable/kubernetes-dashboard"
    name = "kubernetes-dashboard"
    namespace = "kube-system"
    version = "1.10.0"

    # https://github.com/helm/charts/tree/master/stable/kubernetes-dashboard

    set {
      name = "enableSkipLogin"
      value = "true"
    }

    set {
      name = "service.type"
      value = "LoadBalancer"
    }

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