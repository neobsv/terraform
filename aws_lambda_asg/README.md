# terraform
Example terraform IaC for DISPATCH

## Example 2

### Networking
- One VPC created
- Two subnets created in the eu-north-1a availability zone, one is a public subnet for the LB
the other is a private subnet for the ec2 asg instance group
- One Internet Gateway created to connect the VPC and the associated public subnets to the internet

### Security
- Security group created for the vpc allowing http(s) and ssh traffic
- Security group created for the LB, allowing only http traffic
- Security group created for the lambda allowing only ssh traffic outbound to the asg
- Security group created for the asg allowing only ssh traffic inbound from the lb
- Network ACL created for the public subnets allowing http(s) and ssh traffic

## Load Balancer
- A Load Balancer (LB) was created with an HTTPS listener
- This is done to expose the ASG instances to the internet
- The LB was attached to the private subnet for the ASG, and appropriate security groups were attached to the LB

### ASG
- A launch configuration for the ASG was created with the t3.micro instance type, ami, and security group
- An Auto Scaling Group (ASG) was created with min 1 instance, just as an example to illustrate

### Lambda Function used to dispatch events/invoke containers or functions inside the ASG
- A Lambda function was created with the provided zip file containing a simple AWS Lambda function
- The Lambda function was placed inside the private subnet for the ASG, inside the VPC
- The Lambda function was granted execute permissions for the ASG's VPC security group
- The Lambda function is used to invoke or trigger operations inside the ASG

### IAM Roles for the Lambda to allow execute access to the ASG
- An IAM role was created for the Lambda function to allow it to execute tasks on the EC2 instances in the ASG
- An IAM Policy document was created to grant the Lambda function the necessary permissions to execute tasks on the EC2 instances in the ASG
- An IAM Policy for VPC execute was attached to the Lambda function to enable it to execute inside the VPC for the ASG


### Proper plan and dependency graph
- IMPORTANT: Assigning proper depends on relationships to resouces to generate the DEPENDENCY GRAPH CORRECTLY.

