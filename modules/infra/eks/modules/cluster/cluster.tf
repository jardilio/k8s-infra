locals {
  kubeconfig = <<KUBECONFIG
apiVersion: v1
clusters:
- cluster:
    server: ${aws_eks_cluster.cluster.endpoint}
    certificate-authority-data: ${aws_eks_cluster.cluster.certificate_authority.0.data}
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: aws
  name: aws
current-context: aws
kind: Config
preferences: {}
users:
- name: aws
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1alpha1
      command: aws-iam-authenticator
      args:
        - "token"
        - "-i"
        - "${var.name}"
KUBECONFIG
}

resource "aws_eks_cluster" "cluster" {
  name = "${var.name}"
  role_arn = "${aws_iam_role.cluster.arn}"
  # enabled_cluster_log_types = ["api", "audit"]
  version = "${var.kubernetes}"

  vpc_config {
    security_group_ids = ["${aws_security_group.cluster.id}"]
    subnet_ids = aws_subnet.network_public.*.id
    endpoint_private_access = true
    endpoint_public_access = true
  }

  depends_on = [
    "aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy",
    "aws_iam_role_policy_attachment.cluster_AmazonEKSServicePolicy",
    # "aws_cloudwatch_log_group.logs",
    "aws_subnet.network_public"
  ]

  tags = "${var.tags}"
}

resource "aws_iam_role" "cluster" {
  name = "${var.name}-cluster"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
  tags = "${var.tags}"
}

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role = "${aws_iam_role.cluster.name}"
}

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role = "${aws_iam_role.cluster.name}"
}

resource "aws_security_group" "cluster" {
  name = "${var.name}-cluster"
  description = "The default security group for the ${var.name} cluster"
  vpc_id = "${aws_vpc.network.id}"
  tags = "${var.tags}"
}

resource "aws_security_group_rule" "cluster_egress" {
  description = "The default node egress ${var.name} cluster"
  type = "egress"
  from_port = 0
  to_port = 65535
  protocol = "all"
  cidr_blocks = ["${var.private ? var.cidr : "0.0.0.0/0"}"]
  security_group_id = "${aws_security_group.cluster.id}"
}