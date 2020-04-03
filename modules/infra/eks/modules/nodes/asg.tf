locals {
  instance_count = "${var.instance_count == "" ? length(local.cluster_subnets) : number(var.instance_count)}"
#   ami = "${var.instance_image == "" ? data.aws_ami.eks.id : var.instance_image}"
#   userdata = <<USERDATA
# #!/bin/bash
# set -o xtrace
# /etc/eks/bootstrap.sh --apiserver-endpoint '${local.cluster_endpoint}' --b64-cluster-ca '${local.cluster_certificate_authority}' '${var.cluster}'
# USERDATA
}

# resource "aws_launch_configuration" "nodes" {
#   associate_public_ip_address = "${var.private ? false : true}"
#   iam_instance_profile = "${aws_iam_instance_profile.role.name}"
#   image_id = "${local.ami}"
#   instance_type = "${var.instance_type}"
#   name_prefix = "${local.identifier}"
#   security_groups = ["${aws_security_group.node.id}"]
#   user_data_base64 = "${base64encode(local.userdata)}"

#   lifecycle {
#     create_before_destroy = true
#   }
# } 

# data "aws_ami" "eks" {
#   filter {
#     name = "name"
#     values = ["amazon-eks-node-${local.cluster_version}-v*"]
#   }
#   most_recent = true
#   owners = ["602401143452"] # Amazon EKS AMI Account ID
# }

# resource "null_resource" "tags" {
    
# }

# resource "aws_autoscaling_group" "nodes" {
#   desired_capacity = "${local.instance_count}"
#   launch_configuration = "${aws_launch_configuration.nodes.id}"
#   max_size = "${local.instance_count}"
#   min_size = "${local.instance_count}"
#   name = "${local.identifier}"
#   vpc_zone_identifier = local.cluster_subnets

#   tag {
#     key = "Name"
#     value = "${var.cluster}-${var.name}-worker-node"
#     propagate_at_launch = true
#   }

#   tag {
#     key = "kubernetes.io/cluster/${var.cluster}"
#     value = "owned"
#     propagate_at_launch = true
#   }
# }

resource "aws_eks_node_group" "asg" {
  cluster_name = var.cluster
  node_group_name = "${var.cluster}-${var.name}-worker-node"
  node_role_arn = aws_iam_role.role.arn
  subnet_ids = local.cluster_subnets
  instance_types = ["${var.instance_type}"]

  scaling_config {
    desired_size = local.instance_count
    max_size = local.instance_count
    min_size = local.instance_count
  }

  depends_on = [
    aws_iam_role_policy_attachment.role_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.role_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.role_AmazonEC2ContainerRegistryReadOnly,
  ]

  tags = "${merge(var.tags, map("Name", "${var.cluster}-${var.name}-worker-node-asg"))}"
}

