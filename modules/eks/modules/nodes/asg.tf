locals {
  ami = "${var.instance_image == "" ? data.aws_ami.eks.id : var.instance_image}"
  userdata = <<USERDATA
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh --apiserver-endpoint '${local.cluster_endpoint}' --b64-cluster-ca '${local.cluster_certificate_authority}' '${var.cluster}'
USERDATA
}

resource "aws_launch_configuration" "demo" {
  associate_public_ip_address = "${var.private ? false : true}"
  # iam_instance_profile = "${aws_iam_instance_profile.node.name}"
  image_id = "${local.ami}"
  instance_type = "${var.instance_type}"
  name_prefix = "${local.identifier}"
  security_groups = ["${aws_security_group.node.id}"]
  user_data_base64 = "${base64encode(local.userdata)}"

  lifecycle {
    create_before_destroy = true
  }
} 

data "aws_ami" "eks" {
  filter {
    name = "name"
    values = ["amazon-eks-node-${local.cluster_version}-v*"]
  }
  most_recent = true
  owners = ["602401143452"] # Amazon EKS AMI Account ID
}

resource "null_resource" "tags" {
    
}

resource "aws_autoscaling_group" "nodes" {
  desired_capacity = "${var.instance_count}"
  launch_configuration = "${aws_launch_configuration.demo.id}"
  max_size = "${var.instance_count}"
  min_size = "${var.instance_count}"
  name = "${local.identifier}"
  vpc_zone_identifier  = ["${local.cluster_subnets}"]

  tag {
    key = "Name"
    value = "terraform-eks-demo"
    propagate_at_launch = true
  }

  tag {
    key = "kubernetes.io/cluster/${var.cluster}"
    value = "owned"
    propagate_at_launch = true
  }
}