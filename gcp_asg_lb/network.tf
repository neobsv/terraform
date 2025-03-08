resource "google_compute_network" "vpc_network" {
  name = "demo"
}

resource "google_compute_subnetwork" "vpc_subnetwork" {
  name                     = "demo-subnetwork"
  region                   = var.region
  network                  = google_compute_network.vpc_network.id
  ip_cidr_range            = "10.2.0.0/24"
  private_ip_google_access = true

  depends_on = [google_compute_network.vpc_network]
}

# Reserve an external public IP address for customers to access the LB
resource "google_compute_global_address" "lb_address" {
  name       = "lb-ipv4-1"
  ip_version = "IPV4"
}

# URL map: gives a url to the load balancer
resource "google_compute_url_map" "urlmap0" {
  name            = "web-map-http"
  default_service = google_compute_backend_service.lb0.id
}

# HTTPS proxy: Move the traffic from the defined external public IP address to the load balancer
resource "google_compute_target_http_proxy" "httpproxy0" {
  name    = "test-proxy"
  url_map = google_compute_url_map.urlmap0.id
}

# Forwarding rule: Connects the https proxy above to the external public IP address
resource "google_compute_global_forwarding_rule" "rule0" {
  name                  = "http-content-rule"
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  port_range            = "80-80"
  target                = google_compute_target_http_proxy.httpproxy0.id
  ip_address            = google_compute_global_address.lb_address.id
}
