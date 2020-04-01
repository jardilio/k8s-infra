module "gke_example" {
    source = "../../modules/gke"
    project = "devops-demo-216801"
    name = "gke-example"
    region = "us-central1"
    kubernetes_version = "1.13.10"
}