module "cluster" {
    source = "./modules/cluster"
    name = "${var.name}"
    cidr = "${var.cluster_cidr}"
    zones = "${var.zones}"
    kubernetes = "${var.kubernetes_version}"
    instance_image = "${var.cluster_instance_image}"
    instance_type = "${var.cluster_instance_type}"
    instance_count = "${var.cluster_instance_count}"
    tags = "${var.tags}"
}

# module "pci_isoseg" {
#     source = "./modules/nodes"
#     name = "pci_isoseg"
#     cluster = "${module.cluster.id}"
#     instance_image = "${var.pci_isoseg_instance_image}"
#     instance_type = "${var.pci_isoseg_instance_type}"
#     instance_count = "${var.pci_isoseg_instance_count}"
#     tags = "${var.tags}"
# }