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
