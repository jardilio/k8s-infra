resource "google_container_node_pool" "nodegroups" {
    count = "${length(var.nodegroups)}"
    name = "${var.name}-${var.nodegroups[count.index].name}-nodegroup"
    location = "${var.region}"
    cluster = "${google_container_cluster.cluster.name}"
    node_count = "${var.nodegroups[count.index].count}"

    node_config {
      preemptible  = true
      machine_type = "${var.nodegroups[count.index].type}"

      metadata = {
        disable-legacy-endpoints = "true"
      }

      oauth_scopes = [
        "https://www.googleapis.com/auth/logging.write",
        "https://www.googleapis.com/auth/monitoring",
      ]
    }
}