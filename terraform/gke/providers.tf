terraform {
    required_version = "< 0.13"
    backend "local" {}
    # backend "atlas" {}
    # backend "gcs" {}
}

provider "google" {
    version = "~> 2.16"
    region = "${var.region}"
    project = "${var.project}"
}