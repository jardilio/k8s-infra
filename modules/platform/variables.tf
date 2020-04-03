variable "kubeinit" {
    type = "string"
    description = "This is the init script that every platform module must export to set the context for the cluster in kubectl"
}

variable "dependent_on" {
    default = []
    description = "Hack to fake depends_on support in module"
}