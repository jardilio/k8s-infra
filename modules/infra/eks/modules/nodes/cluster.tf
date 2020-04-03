data "aws_eks_cluster" "cluster" {
  name = "${var.cluster}"
}

data "aws_vpc" "cluster" {
  id = "${data.aws_eks_cluster.cluster.vpc_config.0.vpc_id}"
}

locals {
    cluster_vpc = "${data.aws_eks_cluster.cluster.vpc_config.0.vpc_id}"
    cluster_version = "${data.aws_eks_cluster.cluster.version}"
    cluster_sg = "${data.aws_eks_cluster.cluster.vpc_config.0.cluster_security_group_id}"
    cluster_endpoint = "${data.aws_eks_cluster.cluster.endpoint}"
    cluster_certificate_authority = "${data.aws_eks_cluster.cluster.certificate_authority.0.data}"
    cluster_subnets = data.aws_eks_cluster.cluster.vpc_config.0.subnet_ids
    cluster_cidr = data.aws_vpc.cluster.cidr_block_associations.0.cidr_block
}