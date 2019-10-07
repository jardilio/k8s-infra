# Cluster

A terraform module to contruct a single cluster in a given [network](../network)
and creates a default set of [nodes](../nodes) to handle the workload.

# Inputs

* name - The name to give the cluster. Must be unique per account and region.
* cidr - The CIDR block to assoicate with the VPC. Defaults to 10.0.0.0/16.
* subnets - The number of subnets to create.
* kubernetes - The version of kubernetes to run the cluster with.
* tags - The tags to assign to all created resources for tracking purposes.
* See other inputs inherited from [nodes](../nodes)

# Outputs

* name - The name of the cluster.
* vpc - The VPC the cluster is accociated with.
* kubernetes - The version of kubernetes.
* config - The kubernetes config to connect with the cluster.
* role - The AWS ARN for the role created for the cluster.
* security_group - The AWS security group created for the cluster.
* nodes - Nested object of the outputs from the default node group.