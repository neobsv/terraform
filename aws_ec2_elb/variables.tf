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

variable "public_network_interface_ip0" {
  type        = list(string)
  description = "IP address for the private network interface"
  default     = ["10.0.1.10"]
}

variable "private_network_interface_ip1" {
  type        = list(string)
  description = "IP address for the private network interface"
  default     = ["10.0.2.11"]
}

variable "all_cidr_block_sg" {
  type        = list(string)
  description = "List of CIDR blocks for the allowed ingress"
  default     = ["0.0.0.0/0"]
}

variable "vpc_cidr_block_sg" {
  type        = list(string)
  description = "List of CIDR blocks for the allowed ingress"
  default     = ["10.0.0.0/16"]
}

variable "all_cidr_blocks" {
  type        = string
  description = "List of CIDR blocks for the allowed ingress"
  default     = "0.0.0.0/0"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "aws_ami_id" {
  type        = string
  description = "AMI ID for the instance"
  default     = "ami-07a64b147d3500b6a"
}
