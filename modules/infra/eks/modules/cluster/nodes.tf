module "nodes" {
    source = "../nodes"
    cluster = "${aws_eks_cluster.cluster.id}"
    name = "default"
    instance_image = "${var.instance_image}"
    instance_type = "${var.instance_type}"
    instance_count = "${var.instance_count}"
    tags = "${local.tags}"
}