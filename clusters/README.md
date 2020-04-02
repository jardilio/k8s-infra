This directory is used for managing individual clusters on different target platforms. From a single shared repo, you may manage 
multiple clusters for:

* Different environments
* Different products
* Different platform versions

Simply place a directory here and it will be picked up by the entry point as an option. This expects the directory contains
terraform files and will be used as the entrypoint for terraform execution.