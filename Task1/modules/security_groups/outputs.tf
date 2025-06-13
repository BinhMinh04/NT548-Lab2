output "id" {
  description = "Security Group ID"
  value       = aws_security_group.sg.id
}

output "name" {
  description = "Security Group Name"
  value       = aws_security_group.sg.name
}
