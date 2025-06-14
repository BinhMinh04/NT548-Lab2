resource "aws_instance" "ec2" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.vpc_security_group_ids
  key_name                    = var.key_name
  associate_public_ip_address = var.associate_public_ip_address
  monitoring                  = true
  root_block_device {
    volume_size = 8
    volume_type = "gp2"
    encrypted   = true
  }

  metadata_options {
    http_tokens = "required"
  }
  tags = {
    Name = "${var.vpc_name}-${var.name}"
  }
  lifecycle {
    ignore_changes = [ebs_optimized]
  }
}

