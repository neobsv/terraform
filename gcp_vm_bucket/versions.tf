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

