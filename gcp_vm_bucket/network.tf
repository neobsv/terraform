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
