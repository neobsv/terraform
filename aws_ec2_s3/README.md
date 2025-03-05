# terraform
Example terraform IaC for DISTRIBUTED CACHE

## Example 3

### Networking
- One VPC created
- One public subnet created for the ec2 instances and the S3 buckets
- One Internet Gateway created to connect the public subnet to the internet

### Security
- Security group created for the vpc allowing http(s) and ssh traffic
- Security group created for the LB, allowing only http traffic
- Network ACL created for the public subnet allowing http(s) and ssh traffic

## Load Balancer
- A Load Balancer (LB) was created with an HTTPS listener
- This is done to expose the EC2 instance, and the S3 buckets through middleware on the ec2 instance
