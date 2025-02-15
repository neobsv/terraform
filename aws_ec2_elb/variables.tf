variable "vpc_cidr" {
    type = string
    description = "CIDR block for the VPC"
    default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
    type = string
    description = "CIDR block for public subnets"
    default = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
    type = string
    description = "CIDR block for public subnets"
    default = "10.0.2.0/24"
}

variable "private_network_interface_ips" {
    type = list(string)
    description = "IP address for the private network interface"
    default = ["10.0.2.10"]
}

variable "security_group_name" {
    type = string
    description = "Name for the security group"
    default = "vpc0_sg"
}

variable "cidr_block" {
    type = list(string)
    description = "List of CIDR blocks for the allowed ingress"
    default = ["0.0.0.0/0"]
}

variable "availability_zone" {
    type = string
    description = "The AWS availability zone"
    default = "eu-north-1a"
}