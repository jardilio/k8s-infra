# data "google_client_openid_userinfo" "current" {}

# resource "google_project_iam_member" "kube-api-admin" {
#   project = "${var.project}"
#   role = "roles/container.admin"
#   member = "serviceAccount:${google_client_openid_userinfo.current.email}"
# }