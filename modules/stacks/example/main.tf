
# Create a dedicated namespace for all resources in this stack to be linked to
resource "kubernetes_namespace" "example" {
    # hack to force wait for cluster to finish initialize and have istio ready before proceeding
    depends_on = [var.depend_on]
    metadata {
        name = "${var.namespace}"
        labels = {
            istio-injection = "enabled"
        }
    }
}

# Load our Istio template for the gateway we will create for this stack
data "template_file" "example" {
  template = "${file("${path.module}/networking.yaml")}"
  vars = {
    namespace = "${var.namespace}"
    gateway = "${var.namespace}"
  }
}

# Deploy our Istio gateway from the above template
resource "null_resource" "example" {
    triggers = {
        template = "${data.template_file.example.rendered}"
    }

    provisioner "local-exec" {
        environment = {
            TEMPLATE = "${data.template_file.example.rendered}"
        }
        command = "echo \"$TEMPLATE\" | kubectl apply -f -"
    }
    provisioner "local-exec" {
        environment = {
            TEMPLATE = "${data.template_file.example.rendered}"
        }
        when = "destroy"
        on_failure = "continue"
        command = "echo \"$TEMPLATE\" | kubectl delete -f -"
    }
}

# Deploy all our applications and configurations associated with this stack

module "foo" {
    depend_on = [null_resource.example]
    source = "../../apps/generic-web"
    namespace = "${kubernetes_namespace.example.metadata.0.name}"
    app_name = "foo"
    app_image = "nginx"
    app_version = "${var.app_version}"
    min_instances = 1
    max_instances = 1
    gateway = "${var.namespace}"
    url_prefix = "/${var.namespace}/foo/"
}

module "bar" {
    depend_on = [null_resource.example]
    source = "../../apps/generic-web"
    namespace = "${kubernetes_namespace.example.metadata.0.name}"
    app_name = "bar"
    app_image = "nginx"
    app_version = "${var.app_version}"
    min_instances = 1
    max_instances = 1
    gateway = "${var.namespace}"
    url_prefix = "/${var.namespace}/bar/"
}