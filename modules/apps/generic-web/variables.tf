variable "app_name" {
    description = "The name of the application"
}

variable "app_image" {
    description = "The repo and image name for the app"
}

variable "app_version" {
    default = "latest"
    description = "The version of the application to load (ie tag)"
}

variable "namespace" {
    default = "default"
    description = "The name of the namespace to target"
}

variable "min_instances" {
    default = 1
    description = "The minimum number of instances for HPA"
}

variable "max_instances" {
    default = 3
    description = "The maximum number of instances for HPA"
}

variable "url_prefix" {
    default = "/"
    description = "The URL prefix where this app will receive routes from"
}

variable "gateway" {
    description = "The gateway to attach virtual service to"
}

variable depend_on {
    default = []
}