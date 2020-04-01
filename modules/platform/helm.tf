locals {
    helm_stable = "${data.helm_repository.stable.metadata[0].name}"
    helm_incubator = "${data.helm_repository.incubator.metadata[0].name}"
}

data "helm_repository" "incubator" {
  name = "incubator"
  url  = "https://kubernetes-charts-incubator.storage.googleapis.com"
}

data "helm_repository" "stable" {
  name = "stable"
  url  = "https://kubernetes-charts.storage.googleapis.com/"
}