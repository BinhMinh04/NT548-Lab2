output "id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.ec2.id
}

output "private_ip" {
  description = "Private IP address of the EC2 instance"
  value       = aws_instance.ec2.private_ip
}

output "public_ip" {
  description = "Public IP address of the EC2 instance (if applicable)"
  value       = aws_instance.ec2.public_ip
}

output "security_groups" {
  description = "List of associated security groups of the instance"
  value       = aws_instance.ec2.security_groups
}

output "subnet_id" {
  description = "Subnet ID the instance was launched in"
  value       = aws_instance.ec2.subnet_id
}

output "availability_zone" {
  description = "Availability zone of the instance"
  value       = aws_instance.ec2.availability_zone
}
