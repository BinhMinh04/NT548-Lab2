output "nat_gateway_id" {
  description = "NAT Gateway ID"
  #value       = aws_nat_gateway.main.id
  value       = aws_nat_gateway.nat.id
}