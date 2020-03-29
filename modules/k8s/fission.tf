resource "kubernetes_namespace" "fission" {
  metadata {
    name = "fission"
  }
}

resource "helm_release" "fission" {
    count = 0 # disabled for now
    depends_on = ["helm_release.istio"]
    repository = "https://raw.githubusercontent.com/fission/fission-charts/master/"
    chart = "fission-all"
    name = "fission"
    version = "1.5.0"
    namespace = "${kubernetes_namespace.fission.metadata.0.name}"

    # https://github.com/fission/fission/tree/master/charts#configuration

    set {
        name = "serviceType"
        value = "${var.default_service_type}"
    }

    set {
        name = "routerServiceType"
        value = "${var.default_service_type}"
    }

    set {
        name = "enableIstio"
        value = "true"
    }

    set {
        name = "prometheusDeploy"
        value = "false" # handled by istio
    }
}