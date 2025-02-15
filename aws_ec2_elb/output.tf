# output the vpc id
output "vpc_id" {
    value = aws_vpc.vpc0.id
    description = "The ID of the created VPC"
}

# output the id of the private subnet
output "subnet_ids" {
    value = aws_subnet.private.id
    description = "The IDs of the created private subnets"
}

# output the id of the public subnet
 output "public_subnet_id" {
    value = aws_subnet.public.id
    description = "The ID of the created public subnet"
}

# output the internet gateway id
output "internet_gateway_id" {
    value = aws_internet_gateway.igw.id
    description = "The ID of the created internet gateway"
}

# output the id of the security group
 output "security_group_id" {
    value = aws_security_group.sg.id
    description = "The ID of the created security group"
}

# output the id of the aws instance
 output "instance_id0" {
    value = aws_instance.instance0.id
    description = "The ID of the created EC2 instance0"
}

# output the id of the aws instance
 output "instance_id1" {
    value = aws_instance.instance1.id
    description = "The ID of the created EC2 instance1"
}

# ip address of the first instance
output "instance0_private_ip" {
    value = aws_instance.instance0.private_ip
    description = "The private IP of the created EC2 instance0"
}

# ip address of the second instance
output "instance1_private_ip" {
    value = aws_instance.instance1.private_ip
    description = "The private IP of the created EC2 instance1"
}

