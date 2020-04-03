locals {
    tags = merge(var.tags, {
        Name = "${var.name}"
        Cluster = "${var.name}"
    })
}

variable "tags" {
    type = "map"
    default = {}
    description = "A set of tags to apply to all resources for tracking purposes"
}

variable "cidr" {
    default = "10.0.0.0/16"
    description = "The CIDR block to associate with the network that will be created"
}

variable "public_cidr" {
    default = ""
    description = "The CIDR block in 'cidr' used for public space (default is first half of cidr)"
}

variable "private_cidr" {
    default = ""
    description = "The CIDR block in 'cidr' used for private space (default is second half of cidr)"
}

variable "zones" {
    type = "list"
    default = []
    description = "The zones to put the cluster in"
}

variable "private" {
    default = false
    description = "The number of availability zones to create in the network"
}

variable "name" {
    type = "string"
    description = "The name to give the cluster, must be unique per region"
}

variable "kubernetes" {
    type = "string"
    description = "The version of kubernetes to run"
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

locals {
    security_group_ids = ["${aws_security_group.cluster.id}"]
    subnet_ids = ["${aws_subnet.network_public.*.id}"]
}