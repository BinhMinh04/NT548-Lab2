resource "aws_security_group" "sg" {
  name        = var.name
  description = var.description
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.vpc_name}-${var.name}-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "this" {
  for_each = { for idx, rule in var.ingress_rules : idx => rule }

  security_group_id = aws_security_group.sg.id
  
  ip_protocol                  = each.value.protocol
  from_port                    = each.value.from_port
  to_port                      = each.value.to_port
  cidr_ipv4                    = length(each.value.cidr_blocks) > 0 ? each.value.cidr_blocks[0] : null
  referenced_security_group_id = each.value.referenced_security_group
  description                  = each.value.description
}

resource "aws_vpc_security_group_egress_rule" "this" {
  for_each = { for idx, rule in var.egress_rules : idx => rule }

  security_group_id = aws_security_group.sg.id
  
  ip_protocol                  = each.value.protocol
  from_port                    = each.value.from_port
  to_port                      = each.value.to_port
  cidr_ipv4                    = length(each.value.cidr_blocks) > 0 ? each.value.cidr_blocks[0] : null
  referenced_security_group_id = each.value.referenced_security_group
  description                  = each.value.description
}