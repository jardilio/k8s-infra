resource "google_container_cluster" "cluster" {
  name = "${var.name}"
  location = "${var.region}"
  # additional_zones = "${var.zones}"
  node_locations = "${var.zones}"
  min_master_version = "${var.kubernetes_version}"

  remove_default_node_pool = true
  initial_node_count = 1

  master_auth {
    username = ""
    password = ""
    client_certificate_config {
      issue_client_certificate = false
    }
  }
}