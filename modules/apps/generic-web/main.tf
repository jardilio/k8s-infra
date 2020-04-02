resource "kubernetes_deployment" "generic_web" {

  metadata {
    name = "${var.app_name}-${var.app_version}"
    namespace = "${var.namespace}"
    labels = {
      app = "${var.app_name}"
      version = "${var.app_version}"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "${var.app_name}"
        version = "${var.app_version}"
      }
    }

    template {
      metadata {
        namespace = "${var.namespace}"
        labels = {
          app = "${var.app_name}"
          version = "${var.app_version}"
        }
      }

      spec {
        container {
          image = "${var.app_image}:${var.app_version}"
          image_pull_policy = "${var.app_version == "latest" ? "Always" : "IfNotPresent"}"
          name = "${var.app_name}"

          port {
            container_port = 80
          }

          # port {
          #   container_port = 443
          # }

          resources {
            requests {
              cpu    = "125m"
              memory = "20Mi"
            }
          }

          liveness_probe {
            http_get {
              path = "/"
              port = 80
            }
            initial_delay_seconds = 10
            period_seconds = 10
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "generic_web" {
  depends_on = ["kubernetes_deployment.generic_web"]
  metadata {
    name = "${var.app_name}"
    namespace = "${var.namespace}"
  }
  spec {
    selector = {
      app = "${var.app_name}"
      version = "${var.app_version}"
    }

    session_affinity = "ClientIP"

    port {
      name = "http"
      port = 80
      target_port = 80
    }
    
    # port {
    #   name = "https"
    #   port = 443
    #   target_port = 443
    # }

    type = "LoadBalancer"
  }
}

resource "kubernetes_horizontal_pod_autoscaler" "generic_web" {
  # depends_on = ["kubernetes_deployment.generic_web"]

  metadata {
    name = "${var.app_name}"
    namespace = "${var.namespace}"
  }

  spec {
    max_replicas = "${var.max_instances}"
    min_replicas = "${var.min_instances}"
    scale_target_ref {
      api_version = "apps/v1"
      kind = "Deployment"
      name = "${var.app_name}-${var.app_version}"
    }
  }
}