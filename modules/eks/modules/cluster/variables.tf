variable "tags" {
    type = "map"
    description = "A set of tags to apply to all resources for tracking purposes"
}

variable "cidr" {
    default = "10.0.0.0/16"
    description = "The CIDR block to associate with the network that will be created"
}

variable "public_cidr" {
    description = "The CIDR block in 'cidr' used for public space (default is first half of cidr)"
}

variable "private_cidr" {
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