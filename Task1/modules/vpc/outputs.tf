output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "vpc_name" {
  description = "VPC Name"
  value       = aws_vpc.main.tags["Name"]
}

output "public_subnet_id" {
  description = "Public Subnet ID"
  value       = aws_subnet.public.id
}

output "private_subnet_id" {
  description = "Private Subnet ID"
  value       = aws_subnet.private.id
}

output "internet_gateway_id" {
  description = "Internet Gateway ID"
  value       = aws_internet_gateway.main.id
}

output "default_security_group_id" {
  description = "Default Security Group ID"
  value       = aws_default_security_group.default.id
}