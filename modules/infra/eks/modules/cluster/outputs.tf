output "name" {
    value = "${aws_eks_cluster.cluster.id}"
}

output "vpc" {
    value = "${aws_vpc.network.id}"
}

output "kubernetes" {
    value = "${aws_eks_cluster.cluster.version}"
}

output "config" {
    value = "${local.kubeconfig}"
}

output "role" {
    value = "${aws_iam_role.cluster.arn}"
}

output "security_group" {
    value = "${aws_security_group.cluster.id}"
}

output "nodes" {
    value = "${module.nodes}"
}