variable "backend_bucket_name" {
  description = "Name of the static bucket which will be created as a backend"
  type        = string
  default     = "static-data-backend"
}

variable "gcp_bucket_name" {
  description = "Name of the GCP bucket you want to use for static data"
  type        = string
}

variable "gcp_project" {
  description = "gcp project id"
  type        = string
  default     = "please-change-me"
}

variable "gcp_credentials" {
  description = "full path to JSON file or JSOn file in string format with GCP credentials"
  type        = string
  default     = "*"
}

