# AWS Infrastructure Deployment with Terraform

This project uses Terraform to deploy a complete AWS infrastructure with VPC, subnets, security groups, routing tables, NAT Gateway, and EC2 instances. The architecture includes both public and private subnets with appropriate routing and security configurations.

## Architecture Overview

The infrastructure deployed includes:

- **VPC**: A Virtual Private Cloud with CIDR block 10.0.0.0/16
- **Subnets**:
  - Public Subnet (10.0.100.0/24) - Connected to the Internet Gateway
  - Private Subnet (10.0.1.0/24) - Uses NAT Gateway for outbound internet access
- **Gateways**:
  - Internet Gateway - Allows public subnet resources to access the internet
  - NAT Gateway - Allows private subnet resources to access the internet while remaining private
- **Route Tables**:
  - Public Route Table - Routes internet traffic through the Internet Gateway
  - Private Route Table - Routes internet traffic through the NAT Gateway
- **EC2 Instances**:
  - Public EC2 - Deployed in the public subnet, accessible from the internet via SSH
  - Private EC2 - Deployed in the private subnet, accessible only from the public EC2
- **Security Groups**:
  - Public Security Group - Allows SSH (port 22) access from a specific IP
  - Private Security Group - Allows SSH access only from the public EC2 instance

## Prerequisites

- [AWS CLI](https://aws.amazon.com/cli/) installed and configured
- [Terraform](https://www.terraform.io/downloads.html) (v1.0.0 or newer)
- AWS account with appropriate permissions
- SSH key pair for EC2 access (optional)

### Configuring AWS CLI

Before running Terraform, you need to configure your AWS credentials:

```bash
aws configure
```

You will be prompted to enter:
- AWS Access Key ID
- AWS Secret Access Key
- Default region name (e.g., us-east-1)
- Default output format (json is recommended)

Alternatively, you can set environment variables:

```bash
export AWS_ACCESS_KEY_ID="your_access_key"
export AWS_SECRET_ACCESS_KEY="your_secret_key"
export AWS_DEFAULT_REGION="us-east-1"
```

Or create/edit the credentials file manually:

```bash
nano ~/.aws/credentials
```

With the content:
```
[default]
aws_access_key_id = your_access_key
aws_secret_access_key = your_secret_key
```

And configure the region:
```bash
nano ~/.aws/config
```

With the content:
```
[default]
region = us-east-1
```

## Project Structure

```
.
├── main.tf                 # Main Terraform configuration file
├── outputs.tf              # Output definitions
├── modules/                # Terraform modules
│   ├── vpc/                # VPC module
│   ├── nat_gateway/        # NAT Gateway module
│   ├── route_tables/       # Route Tables module
│   ├── security_groups/    # Security Groups module
│   └── ec2/                # EC2 instances module
```

## Configuration

Before deploying, you may want to modify the following configurations in `main.tf`:

1. Update the `region` in the AWS provider block
2. Modify CIDR blocks for VPC and subnets if needed
3. Update the allowed IP address in the public security group
4. Change EC2 instance types or AMI IDs if needed
5. Add your SSH key pair name if you want to SSH into instances

## Deployment Instructions

Follow these steps to deploy the infrastructure:

### 1. Clone the repository

```bash
git clone https://github.com/Giabaoday/NT548.P21-BaiTapThucHanh1
cd NT548.P21-BaiTapThucHanh1
```

### 2. Initialize Terraform

```bash
terraform init
```

### 3. Check the deployment plan

```bash
terraform plan
```

Review the plan to ensure it will create all the expected resources without destroying any existing resources.

### 4. Deploy the infrastructure

```bash
terraform apply
```

Type `yes` when prompted to confirm the deployment.

### 5. Access your resources

After successful deployment, Terraform will output various resource IDs and IPs. You can access your public EC2 instance via SSH:

```bash
ssh -i /path/to/your-key.pem ec2-user@<public_instance_public_ip>
```

To access the private EC2 instance, you'll need to SSH into the public instance first, then SSH to the private instance:

```bash
# From within the public instance
ssh -i /path/to/your-key.pem ec2-user@<private_instance_public_ip>
```

## Destroying the Infrastructure

When you're finished with the infrastructure, you can destroy it to avoid incurring any additional costs:

```bash
terraform destroy
```

Type `yes` when prompted to confirm.

## Troubleshooting

### Common Issues

1. **Elastic IP Limit**: AWS accounts have a default limit of 5 Elastic IPs per region. If you hit this limit, request an increase from AWS.

2. **SSH Connection Issues**: 
   - Verify your security group allows SSH from your IP address
   - Check that you're using the correct SSH key
   - Ensure the instance is in a "running" state

3. **Unable to Access Internet from Private Instance**:
   - Verify the NAT Gateway is running
   - Check route tables for correct configuration
   - Verify security groups allow outbound traffic

4. **Permission Errors**:
   - Ensure your AWS credentials have sufficient permissions
   - Check IAM policies if using roles

For any other issues, check the AWS Console for resource status and Terraform error messages.

## Additional Notes

- The current configuration uses `t3.micro` instances to stay within the AWS Free Tier limits
- The AMI ID used (`ami-0f88e80871fd81e91`) is for Amazon Linux 2023 in the us-east-1 region. You may need to change this for other regions
- Security groups are configured for minimal access - adjust as needed for your use case

