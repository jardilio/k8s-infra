# Nodes

A terraform module to create a set of worker nodes to attach
to a given [cluster](../cluster).

# Inputs

* name - The name to give the nodes. Must be unique per account and region.
* cluster - The [cluster](../cluster) to associate the nodes with.
* instance_image - The AWS AMI for the instance. Optional, default will find latest for `kubernetes` version of cluster.
* instance_type - The AWS instance type for the nodes
* instance_count - The number of nodes to create
* tags - The tags to assign to all created resources for tracking purposes.

# Outputs

* name - The name of the cluster.
* nodeSelector - The selector used to target pods to the nodes.
* role - The AWS ARN for the role created for the cluster.
* security_group - The AWS security group created for the cluster.