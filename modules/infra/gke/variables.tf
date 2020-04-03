variable "region" {
    type = "string"
    description = "The default region to place the cluster in"
}

variable "project" {
    type = "string"
    description = "The project to manage this cluster in"
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

variable "nodegroups" {
    type = "list"
    description = "List of node groups to create for the cluster"
    default = [
        {
            name = "default"
            type = "n1-standard-2"
            count = 1 #NOTE: this is per zone NOT total
        }
    ]
}