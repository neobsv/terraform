# Create a vm instance in us-west-1 Oregon
resource "google_service_account" "default" {
  account_id   = "my-custom-sa"
  display_name = "Custom SA for VM Instance"
}

resource "google_compute_autoscaler" "asg0" {
  name   = "asg0"
  zone   = var.zone
  target = google_compute_instance_group_manager.igm0.id

  autoscaling_policy {
    max_replicas    = 3
    min_replicas    = 1
    cooldown_period = 60

    cpu_utilization {
      target = 0.5
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [google_compute_instance_group_manager.igm0]
}

resource "google_compute_instance_group_manager" "igm0" {
  name = "igm0"
  zone = var.zone

  version {
    instance_template = google_compute_instance_template.igmtemplate0.id
    name              = "primary"
  }

  target_pools       = [google_compute_target_pool.pool0.id]
  base_instance_name = "example"

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [google_compute_instance_template.igmtemplate0]
}

resource "google_compute_instance_template" "igmtemplate0" {
  name           = "my-instance-template"
  machine_type   = "e2-micro"
  can_ip_forward = false

  tags = ["test", "instancegroup"]

  disk {
    source_image = data.google_compute_image.fedora_latest.id
  }

  network_interface {
    network    = google_compute_network.vpc_network.name
    subnetwork = google_compute_subnetwork.vpc_subnetwork.name
    access_config {}
  }

  metadata = {
    test = "instancegroup"
  }

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.default.email
    scopes = ["cloud-platform"]
  }

  depends_on = [google_compute_subnetwork.vpc_subnetwork]

}

resource "google_compute_target_pool" "pool0" {
  name = "my-target-pool"
}

data "google_compute_image" "fedora_latest" {
  family  = "fedora-coreos-stable-arm64"
  project = "fedora-coreos-cloud"
}

# LB Health Check Service
resource "google_compute_health_check" "hc0" {
  name               = "http-basic-check"
  check_interval_sec = 5
  healthy_threshold  = 2
  http_health_check {
    port               = 80
    port_specification = "USE_FIXED_PORT"
    proxy_header       = "NONE"
    request_path       = "/"
  }
  timeout_sec         = 5
  unhealthy_threshold = 2

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [google_compute_firewall.healthcheck]
}

# A global external Application Load Balancer with advanced traffic management capability "MANAGED_EXTERNAL"; to setup a basic one change the load balancing scheme to "EXTERNAL"
resource "google_compute_backend_service" "lb0" {
  name                            = "loadbalancer0"
  connection_draining_timeout_sec = 0
  health_checks                   = [google_compute_health_check.hc0.id]
  load_balancing_scheme           = "EXTERNAL_MANAGED"
  port_name                       = "http"
  protocol                        = "HTTP"
  session_affinity                = "NONE"
  timeout_sec                     = 30
  backend {
    group           = google_compute_instance_group_manager.igm0.instance_group
    balancing_mode  = "UTILIZATION"
    capacity_scaler = 1.0
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [google_compute_health_check.hc0]
}

