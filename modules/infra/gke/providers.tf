provider "google" {
    version = "~> 2.16"
    region = "${var.region}"
    project = "${var.project}"
}