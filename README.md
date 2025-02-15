# terraform
Example terraform IaC that I created on aws involving networking, ec2, s3, elb and others

## Example 1

### Networking
- One VPC created
- Two subnets created in the eu-north-1a availability zone, one is a public subnet for the elb
the other is a private subnet for the ec2 instances
- One Internet Gateway created to connect the VPC and the associated subnets to the internet

### Security
- Security group created for the vpc allowing http(s) and ssh traffic
- Security group created for the ELB, allowing only http(s) traffic
- Network ACL created for the internet gateway allowing http(s) and ssh traffic

### EC2 instances and an ELB
- Two EC2 instances created inside private subnets with network interfaces
- One elb created which points to the two instances

### Proper plan and dependency graph
- IMPORTANT: Assigning proper depends on relationships to resouces to generate the DEPENDENCY GRAPH CORRECTLY.

