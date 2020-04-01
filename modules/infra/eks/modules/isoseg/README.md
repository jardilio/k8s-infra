# Isoseg

A terraform module to contruct an isolation segment in the given [cluster](../cluster). 
This consists of a separate set of [nodes](../nodes) to handle the workload and 
a separate namespace to manage RBAC and POD assignments to the separate nodes.

# Inputs

* name - The name to give the isoseg for namespace and node identification. Must be unique per cluster.
* cluster - The cluster to attach to.
* See other inputs inherited from [nodes](../nodes)

# Outputs

* namespace - The namespace of the isoseg.
* nodeSelector - The nodeSelector used for POD assignments (defaulted in namespace).
* nodes - Nested object of the outputs from the default node group.