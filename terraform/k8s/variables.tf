variable "kubeinit" {
    type = "string"
    description = "This is the init script that every platform module must export to set the context for the cluster in kubectl"
}

variable "default_service_type" {
    type = "string"
    default = "LoadBalancer"
    description = "The default service type to use for external services such as Istio and Fission"
}

variable "dependent_on" {
    default = []
    description = "Hack to fake depends_on support in module"
}