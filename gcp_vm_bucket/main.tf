# Create a vm instance in us-west-1 Oregon
resource "google_service_account" "default" {
  account_id   = "my-custom-sa"
  display_name = "Custom SA for VM Instance"
}

resource "google_compute_instance" "instance0" {
  name         = "my-instance"
  machine_type = "e2-micro"
  zone         = var.zone

  tags = ["test", "instance"]

  boot_disk {
    auto_delete = true
    initialize_params {
      image = var.instance_os
      labels = {
        instance = "centos"
      }
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.name
    access_config {}
  }

  metadata = {
    test = "instance"
  }

  metadata_startup_script = "echo hi > /test.txt"

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.default.email
    scopes = ["cloud-platform"]
  }

  depends_on = [google_compute_network.vpc_network]

}

resource "google_storage_bucket" "strange_bucket0" {
  name                        = "strange_bucket0"
  location                    = var.region
  uniform_bucket_level_access = true
  force_destroy               = true
}

