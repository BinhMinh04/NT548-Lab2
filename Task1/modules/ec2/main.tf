resource "aws_instance" "ec2" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.vpc_security_group_ids
  key_name                    = var.key_name
  user_data                   = var.user_data
  associate_public_ip_address = var.associate_public_ip_address

  tags = {
    Name = "${var.vpc_name}-${var.name}"
  }
}
