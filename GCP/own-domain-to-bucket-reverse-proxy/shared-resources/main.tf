resource "google_compute_backend_bucket" "default" {
  project     = var.gcp_project
  name        = var.backend_bucket_name
  description = "contains static website data for publishing"
  bucket_name = var.gcp_bucket_name
}

