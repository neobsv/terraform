resource "google_compute_firewall" "firewall_allow_internal" {
  name    = "allow-internal-tcp"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["80", "443", "22"]
  }

  source_ranges = ["0.0.0.0/0"]
  source_tags   = ["server"]

  depends_on = [google_compute_network.vpc_network]
}

resource "google_compute_firewall" "healthcheck" {
  name          = "fw-allow-health-check"
  direction     = "INGRESS"
  network       = google_compute_network.vpc_network.name
  priority      = 1000
  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"] # Static IP ranges of the Google Cloud Health Check Systems
  target_tags   = ["allow-health-check"]
  allow {
    ports    = ["80"]
    protocol = "tcp"
  }

  depends_on = [google_compute_network.vpc_network]
}