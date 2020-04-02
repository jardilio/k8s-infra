terraform {
    required_version = "< 0.13"
    # TODO: select your terraform state backend management platform
    backend "local" {}
    # backend "atlas" {}
    # backend "s3" {}
}

provider "aws" {
    version = "~> 2.24"
    region = "${var.region}"
}