# GCP reverse proxy and patch rewrite to a bucket storage

This example contains two TF charts:
* [shared resources](./shared-resources), which should be deployed first and will be shared across your reverse proxies
* [blueprint](./blueprint) this is the TF chart you need to copy, rename and init and will be served as your
  deployment files for each dedicated reverse proxy

This TF plan create a new HTTP and HTTPS frontend LB, which will be using a dedicated SSL cert per domain.
The requests path wil be rewritten and each unique domain and deployment points to a selected folder
in your static bucket. We will then create a new External IP which will be pointing to the sites LB.

Flow: 
gcp subdomain => 
gcp external ip => 
gcp ssl cert => 
gcp lb rule => 
gcp url path rewrite => 
gcp backend (storage)
