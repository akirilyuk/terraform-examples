# Install the GitLab CI Runner infrastructure
module "project-domain" {
  source = "../https-lb-domain"

  gcp_project        = var.gcp_project
  site_name          = var.site_name
  static_bucket_id   = var.static_bucket_id
  with_headers       = var.with_headers
  static_page_domain = var.static_page_domain
  gcp_credentials    = var.gcp_credentials
}