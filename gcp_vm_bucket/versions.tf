terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.20"
    }
  }
}

provider "google" {
  project = var.project_name
  region  = var.region
  zone    = var.zone
}

resource "google_compute_network" "vpc_network" {
  name = "demo"
}
