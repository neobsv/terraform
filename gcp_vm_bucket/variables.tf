variable "zone" {
  type        = string
  description = "GCP zone name for Oregon"
  default     = "us-west1-b"
}

variable "instance_os" {
  type        = string
  description = "Operating system for the GCP instance"
  default     = "projects/centos-cloud/global/images/centos-stream-9-v20250212"
}

variable "project_name" {
  type        = string
  description = "Project name for GCP resources"
  default     = "forward-alchemy-451915-i9"
}

variable "region" {
  type        = string
  description = "GCP region for Oregon"
  default     = "us-west1"
}