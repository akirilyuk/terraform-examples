output "static_bucket_id" {
  value       = google_compute_backend_bucket.default.id
  description = "static bucket id to use for hosting"
}