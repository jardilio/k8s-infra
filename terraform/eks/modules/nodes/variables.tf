locals {
    node_selector_name = "node_group"
    node_selector_vale = "${var.name}"
    node_selector = "${local.node_selector_name}=${local.node_selector_vale}"
    identifier = "${var.cluster}-${node_selector_name}-${var.name}"
}