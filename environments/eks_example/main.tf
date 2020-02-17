module "eks_example" {
    source = "../../modules/eks"
    name = "eks-example"
    region = "us-east1"
    kubernetes_version = "1.13.10"
}