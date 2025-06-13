output "public_route_table_id" {
  description = "Public Route table ID"
  value       = aws_route_table.public.id
}

output "private_route_table_id" {
  description = "Private Route table ID"
  value       = aws_route_table.private.id
}
