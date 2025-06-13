# Outputs for VPC
output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "vpc_name" {
  description = "Name of the VPC"
  value       = module.vpc.vpc_name
}

# Outputs for Subnets
output "public_subnet_id" {
  description = "ID of the public subnet"
  value       = module.vpc.public_subnet_id
}

output "private_subnet_id" {
  description = "ID of the private subnet"
  value       = module.vpc.private_subnet_id
}

# Outputs for EC2 instances
output "public_instance_id" {
  description = "ID of the public EC2 instance"
  value       = module.public_ec2.id
}

output "public_instance_public_ip" {
  description = "Public IP of the public EC2 instance"
  value       = module.public_ec2.public_ip
}

output "private_instance_id" {
  description = "ID of the private EC2 instance"
  value       = module.private_ec2.id
}

output "private_instance_private_ip" {
  description = "Private IP of the private EC2 instance"
  value       = module.private_ec2.private_ip
}

# Outputs for Security Groups
output "public_sg_id" {
  description = "ID of the public security group"
  value       = module.public_sg.id
}

output "private_sg_id" {
  description = "ID of the private security group"
  value       = module.private_sg.id
}

# Output for NAT Gateway
output "nat_gateway_id" {
  description = "ID of the NAT Gateway"
  value       = module.nat_gateway.nat_gateway_id
}