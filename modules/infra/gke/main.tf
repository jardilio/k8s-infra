module "k8s" {
    source = "../k8s"
    kubeinit = "gcloud container clusters get-credentials ${var.name} --region ${var.region} --project ${var.project}"
    default_service_type = "LoadBalancer"
    # wait to load this module until we have a cluster to target
    dependent_on = [
        "${google_container_cluster.cluster.endpoint}",
        "${google_container_node_pool.nodegroups.*.cluster}"
    ]
}