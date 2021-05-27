resource "google_compute_global_forwarding_rule" "default" {
  name       = "${var.sys_name}-${var.env}-lb-frontend"
  target     = google_compute_target_https_proxy.default.id
  port_range = "443"
  ip_version = "IPV4"
}

resource "google_compute_managed_ssl_certificate" "default" {
  name = "${var.sys_name}-${var.env}-cert"
  managed {
    domains = ["ksaito.dev"]
  }
}

resource "google_compute_target_https_proxy" "default" {
  name        = "${var.sys_name}-${var.env}-https-proxy"
  url_map     = google_compute_url_map.default.id
  ssl_certificates = [
    google_compute_managed_ssl_certificate.default.id
  ]
}

resource "google_compute_url_map" "default" {
  name            = "${var.sys_name}-${var.env}-lb"
  default_service = google_compute_backend_service.default.id
}

resource "google_compute_region_network_endpoint_group" "cloudrun_neg" {
  name                  = "${var.sys_name}-${var.env}-neg"
  network_endpoint_type = "SERVERLESS"
  region                = var.region
  cloud_run {
    service = var.app_name
  }
}

resource "google_compute_backend_service" "default" {
  name        = "${var.sys_name}-${var.env}-lb-backend"
  protocol    = "HTTP"
  port_name   = "http"
  timeout_sec = 30
  backend {
    group = google_compute_region_network_endpoint_group.cloudrun_neg.id
  }
}
