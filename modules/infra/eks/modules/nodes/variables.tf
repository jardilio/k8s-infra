locals {
    node_selector_name = "node_group"
    node_selector_vale = "${var.name}"
    node_selector = "${local.node_selector_name}=${local.node_selector_vale}"
    identifier = "${var.cluster}-${local.node_selector_name}-${var.name}"
    tags = merge(var.tags, {
        Name = "${local.identifier}"
        ClusterNodeGroup = "${local.identifier}"
    })
}

variable "name" {
    type = "string"
    description = "The name to give the node group, must be unique per cluster"
}

variable "cluster" {
    type = "string"
    description = "The name to give the cluster, must be unique per region"
}

variable "instance_image" {
    type = "string"
    default = ""
    description = "The image to run for worker nodes (default auto-select)"
}

variable "instance_type" {
    type = "string"
    description = "The instance type for worker nodes"
}

variable "instance_count" {
    type = "string"
    description = "The number of worker nodes to run"
}

variable "tags" {
    type = "map"
    default = {}
    description = "A set of tags to apply to all resources for tracking purposes"
}

variable "cluster_subnets" {
    type = "map"
    default = {}
    description = "A set of tags to apply to all resources for tracking purposes"
}

variable "private" {
    default = false
    description = "Make nodes private or public"
}