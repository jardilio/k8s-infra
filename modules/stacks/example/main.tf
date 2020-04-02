
# resource "kubernetes_namespace" "example" {
#     # hack to force wait for cluster to finish initialize and have istio ready before proceeding
#     depends_on = [var.kubecontext]
#     metadata {
#         name = "example"
#         labels = {
#             istio-injection = "enabled"
#         }
#     }
# }

# module "nginx" {
#     source = "../../apps/generic-web"
#     namespace = "${kubernetes_namespace.example.metadata.0.name}"
#     app_name = "nginx"
#     app_image = "nginx"
#     app_version = "1.14.2"
#     min_instances = 1
#     max_instances = 1
# }

# data "template_file" "example" {
#   template = "${file("${path.module}/networking.yaml")}"
#   vars = {
#     # Place any variables here for interpolation in the template between clusters
#   }
# }

# resource "null_resource" "example" {

#     depends_on = [
#         "module.nginx",
#         "data.template_file.example"
#     ]

#     triggers = {
#         template = "${data.template_file.example.rendered}"
#     }

#     provisioner "local-exec" {
#         environment = {
#             TEMPLATE = "${data.template_file.example.rendered}"
#         }
#         command = "echo \"$TEMPLATE\" | kubectl apply -f -"
#     }
#     provisioner "local-exec" {
#         environment = {
#             TEMPLATE = "${data.template_file.example.rendered}"
#         }
#         when = "destroy"
#         on_failure = "continue"
#         command = "echo \"$TEMPLATE\" | kubectl delete -f -"
#     }
# }