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

variable "project_name" {
  type        = string
  description = "Project name for GCP resources"
  default     = "forward-alchemy-451915-i9"
}
