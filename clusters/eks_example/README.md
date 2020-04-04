This example cluster will:

* Create an cluster infra on AWS using EKS
* Deploy the common platform including Istioter
* Deploy 3 example "stacks" which include:
    * NGINX version 1.17 picking up routes on `/dev/foo` and `/dev/bar`
    * NGINX version 1.16 picking up routes on `/qa/foo` and `/qa/bar`
    * NGINX version 1.15 picking up routes on `/uat/foo` and `/uat/bar`

See [example stack](../../modules/stacks/example)