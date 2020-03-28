resource "kubernetes_service_account" "helm" {
  metadata {
    name      = "tiller"
    namespace = "kube-system"
  }

  automount_service_account_token = true
}

resource "kubernetes_cluster_role_binding" "helm" {
    depends_on = ["kubernetes_service_account.helm"]
    metadata {
        name = "tiller-binding"
    }

    subject {
        kind      = "ServiceAccount"
        name      = "tiller"
        namespace = "kube-system"
    }

    role_ref {
        kind      = "ClusterRole"
        name      = "cluster-admin"
        api_group = "rbac.authorization.k8s.io"
    }
}

resource "null_resource" "helm_init" {
    depends_on = ["kubernetes_cluster_role_binding.helm"]
    triggers = {
        # always trigger this to run and set our kubernetes context
        timestamp = "${timestamp()}"
    }
    provisioner "local-exec" {
        command = "helm init --service-account=tiller --wait"
    } 
    provisioner "local-exec" {
        when = "destroy"
        command = "helm reset --force || true"
    } 
}