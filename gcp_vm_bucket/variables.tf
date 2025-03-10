variable "zone" {
  type        = string
  description = "GCP zone name for Oregon"
  default     = "us-west1-b"
}

variable "region" {
  type        = string
  description = "GCP zone name for Oregon"
  default     = "us-west1"
}

variable "instance_os" {
  type        = string
  description = "Operating system for the GCP instance"
  default     = "projects/fedora-coreos-cloud/global/images/fedora-coreos-41-20250215-3-0-gcp-x86-64"
}

variable "project_name" {
  type        = string
  description = "Project name for GCP resources"
  default     = "forward-alchemy-451915-i9"
}
