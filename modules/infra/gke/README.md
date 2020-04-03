Creates and manages a GKE cluster on Google Cloud Platform. 

This requires the terraform gcp provider to authethenticate with GCP:

* Create a service account in GCP for your target project: https://cloud.google.com/iam/docs/creating-managing-service-accounts
* Ensure the IAM role attached to the service account has the appropriate permissions for Kubernetes Admin
* Download the service key JSON file
* Set your `GOOGLE_APPLICATION_CREDENTIALS` environment variable to either:
    * A path to the location of the JSON file (make sure its accessible to the container and doesn't check into SCM)
    * The value of the JSON files contents

The environment value `GOOGLE_APPLICATION_CREDENTIALS` should be accessible in the context that terraform is running. If you create a`.env` file at the root of this project and define it there, it will be loaded by the container automatically and the file will NOT be checked into SCM via `.gitignore`. The containers entrypoint will also read this value and make it avaiable to the gcloud cli in the console.

The user account running Terraform for this module will required the following roles (to verify, may be able to tighten this up):

* App Engine Admin
* App Engine Deployer
* App Engine Service Admin
* Compute Storage Admin
* Kubernetes Engine Admin
* Deployment Manager Editor
* Storage Admin
* Storage Object Admin
* Owner

* [inputs](./variables.tf)
* [outputs](./outputs.tf)