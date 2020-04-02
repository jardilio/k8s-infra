output "kubeinit" {
    depends_on = [
        "google_container_cluster.cluster",
        "google_container_node_pool.node_groups"
    ]
    value = "gcloud container clusters get-credentials ${var.name} --region ${var.region} --project ${var.project}"
}