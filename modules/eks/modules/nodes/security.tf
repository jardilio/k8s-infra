resource "aws_security_group" "node" {
  name        = "${local.identifier}"
  description = "Security group for all ${var.name} nodes in the ${var.cluster} cluster"
  vpc_id      = "${var.vpc}"

  tags = "${
    merge(
        var.tags,
        map("kubernetes.io/cluster/${var.cluster}", "owned")
    )
  }"
}

resource "aws_security_group_rule" "egress-default" {
  description = "Default egress for ${var.name} nodes in the ${var.name} cluster"
  from_port = 0
  protocol = "-1"
  security_group_id = "${aws_security_group.node.id}"
  cidr_blocks = ["${var.private ? "" : "0.0.0.0/0"}"]
  source_security_group_id = "${aws_security_group.node.id}"
  to_port = 65535
  type = "egress"
}

resource "aws_security_group_rule" "ingress-self" {
  description = "Allow ${var.name} nodes to communicate with each other"
  from_port = 0
  protocol = "-1"
  security_group_id = "${aws_security_group.node.id}"
  source_security_group_id = "${aws_security_group.node.id}"
  to_port = 65535
  type = "ingress"
}

resource "aws_security_group_rule" "ingress-cluster" {
  description = "Allow ${var.name} worker Kubelets and pods to receive communication from the ${var.name} cluster control plane"
  from_port = 1025
  protocol = "tcp"
  security_group_id = "${locals.cluster_sg}"
  source_security_group_id = "${aws_security_group.demo-cluster.id}"
  to_port = 65535
  type = "ingress"
}

resource "aws_security_group_rule" "ingress-api" {
  description = "Allow ${var.name} pods to communicate with the ${var.name} cluster API Server"
  from_port = 443
  protocol = "tcp"
  security_group_id = "${locals.cluster_sg}"
  source_security_group_id = "${aws_security_group.node.id}"
  to_port = 443
  type = "ingress"
}