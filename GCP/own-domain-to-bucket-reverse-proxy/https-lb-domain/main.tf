/**
 * Copyright 2022 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
terraform {
  required_providers {
    google = {
    }
  }
}


provider "google" {
  project     = var.gcp_project
  credentials = var.gcp_credentials
}

resource "google_compute_global_address" "default" {
  name = "${var.site_name}-external-ip"
}

resource "google_compute_url_map" "default" {
  name = "${var.site_name}-https-url-map"

  default_service = var.static_bucket_id
  host_rule {
    hosts        = [local.full_page_hostname]
    path_matcher = "all-paths"
  }
  header_action {
    response_headers_to_add {
      header_name  = "${var.with_headers == "true" ? "" : "X-"}Example-Response-Header"
      header_value = "value"
      replace      = false
    }
    request_headers_to_add {
      header_name  = "${var.with_headers == "true" ? "" : "X-"}Example-Request-Header"
      header_value = "value"
      replace      = false
    }
  }
  path_matcher {
    name            = "all-paths"
    default_service = var.static_bucket_id
    path_rule {
      paths   = ["/"]
      service = var.static_bucket_id
      route_action {
        url_rewrite {
          host_rewrite        = "storage.googleapis.com"
          path_prefix_rewrite = "/${var.site_name}/index.html"
        }
      }
    }
    path_rule {
      paths   = ["/*"]
      service = var.static_bucket_id
      route_action {
        url_rewrite {
          host_rewrite        = "storage.googleapis.com"
          path_prefix_rewrite = "/${var.site_name}/"
        }
      }
    }
  }
}

resource "google_compute_url_map" "https_redirect" {
  name = "${var.site_name}-https-redirect"
  default_url_redirect {
    https_redirect         = true
    strip_query            = false
    redirect_response_code = "MOVED_PERMANENTLY_DEFAULT"
  }
}

resource "google_compute_target_http_proxy" "default" {
  name    = "${var.site_name}-http-lb-proxy"
  url_map = google_compute_url_map.https_redirect.id
}

resource "google_compute_global_forwarding_rule" "default_rule" {
  name                  = "${var.site_name}-http-lb-forwarding-rule"
  port_range            = "80"
  target                = google_compute_target_http_proxy.default.id
  ip_address            = google_compute_global_address.default.id
  load_balancing_scheme = "EXTERNAL_MANAGED"
}

resource "google_compute_managed_ssl_certificate" "default" {
  name = "${var.site_name}-reverse-proxy-lb-cert"
  managed {
    domains = ["${local.full_page_hostname}."]
  }
}

resource "google_compute_target_https_proxy" "default" {
  name             = "${var.site_name}-https-lb-proxy"
  url_map          = google_compute_url_map.default.id
  ssl_certificates = [google_compute_managed_ssl_certificate.default.id]
}

resource "google_compute_global_forwarding_rule" "default" {
  name                  = "${var.site_name}-https-lb-forwarding-rule"
  target                = google_compute_target_https_proxy.default.id
  ip_address            = google_compute_global_address.default.id
  port_range            = 443
  load_balancing_scheme = "EXTERNAL_MANAGED"
}

resource "google_dns_record_set" "default" {
  name         = "${local.full_page_hostname}."
  type         = "A"
  ttl          = 300
  managed_zone = var.gcp_dns_zone_name
  rrdatas      = [google_compute_global_address.default.address]
}
