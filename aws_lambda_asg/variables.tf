variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  type        = string
  description = "CIDR block for public subnets"
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  type        = string
  description = "CIDR block for public subnets"
  default     = "10.0.2.0/24"
}

variable "all_cidr_block" {
  type        = list(string)
  description = "List of CIDR blocks for the allowed ingress"
  default     = ["0.0.0.0/0"]
}
