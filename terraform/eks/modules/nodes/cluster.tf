data "aws_eks_cluster" "cluster" {
  name = "${var.cluster}"
}

locals {
    cluster_vpc = "${data.aws_eks_cluster.cluster.vpc_config.vpc_id}"
    cluster_version = "${data.aws_eks_cluster.cluster.version}"
    cluster_sg = "${data.aws_eks_cluster.cluster.vpc_config.security_group_ids[0]}"
    cluster_endpoing = "${data.aws_eks_cluster.cluster.endpoint}"
    cluster_certificate_authority = "${data.aws_eks_cluster.certificate_authority.0.data}"
    cluster_subnets = "${data.aws_eks_cluster.cluster.vpc_config.subnet_ids}"
}