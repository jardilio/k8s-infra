variable "region" {
    type = "string"
    description = "The region the cluster will be associated with"
}

variable "name" {
    type = "string"
    description = "The name to give the cluster"
}

variable "kubernetes_version" {
    type = "string"
    description = "The version of kubernetes to setup"
}

variable "zones" {
    type = "list"
    default = []
    description = "The zones to put the cluster in"
}

variable "tags" {
    type = "map"
    default = {}
    description = "A set of tags to apply to all resources for tracking purposes"
}

variable "cluster_cidr" {
    type = "string"
    default = "10.0.0.0/16"
    description = "The CIDR block to associate with the network that will be created"
}

variable "cluster_instance_image" {
    type = "string"
    default = ""
    description = "The image to run for worker nodes (default auto-select)"
}

variable "cluster_instance_type" {
    type = "string"
    default = "c5.large"
    description = "The instance type for worker nodes"
}

variable "cluster_instance_count" {
    type = "string"
    default = ""
    description = "The number of worker nodes to run"
}

# variable "pci_isoseg_instance_image" {
#     type = "string"
#     default = ""
#     description = "The image to run for worker nodes (default auto-select)"
# }

# variable "pci_isoseg_instance_type" {
#     type = "string"
#     description = "The instance type for worker nodes"
# }

# variable "pci_isoseg_instance_count" {
#     type = "string"
#     default = ""
#     description = "The number of worker nodes to run"
# }