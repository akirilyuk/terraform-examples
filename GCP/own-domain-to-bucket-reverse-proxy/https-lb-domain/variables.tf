variable "site_name" {
  description = "your subdomain name"
  type        = string
  default     = "my-example"
}

variable "with_headers" {
  description = "use custom headers"
  type        = string
  default     = "true"
}

variable "static_bucket_id" {
  description = "id of the static bucket backend service"
  type        = string
  default     = ""
}

variable "gcp_project" {
  description = "gcp project id"
  type        = string
  default     = ""
}

variable "gcp_dns_zone_name" {
  description = "gcp dns zone name"
  type        = string
  default     = ""
}

variable "static_page_domain" {
  description = "the full which will be used for the static page hosting"
  type        = string
  default     = "my.domain.example.com"
}

variable "gcp_credentials" {
  description = "full path to JSON file or JSOn file in string format with GCP credentials"
  type        = string
  default     = ""
}

locals {
  full_page_hostname = "${var.site_name}.${var.static_page_domain}"
}

