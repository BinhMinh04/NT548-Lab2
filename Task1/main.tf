provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source = "./modules/vpc"

  vpc_name            = "my-vpc"
  vpc_cidr            = "10.0.0.0/16"
  public_subnet_cidr  = "10.0.100.0/24"
  private_subnet_cidr = "10.0.1.0/24"
}

module "nat_gateway" {
  source = "./modules/nat_gateway"

  vpc_name         = module.vpc.vpc_name
  public_subnet_id = module.vpc.public_subnet_id
}

module "route_tables" {
  source = "./modules/route_tables"

  vpc_id              = module.vpc.vpc_id
  public_subnet_id    = module.vpc.public_subnet_id
  private_subnet_id   = module.vpc.private_subnet_id
  internet_gateway_id = module.vpc.internet_gateway_id
  nat_gateway_id      = module.nat_gateway.nat_gateway_id
}

module "public_sg" {
  source = "./modules/security_groups"

  name        = "public-instance-security-group"
  description = "Security group for public instances"
  vpc_name    = module.vpc.vpc_name
  vpc_id      = module.vpc.vpc_id

  ingress_rules = [
    {
      description = "Allow SSH from my IP"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["118.70.53.89/23"]
    }
  ]

  egress_rules = [
    {
      description = "Allow all outbound traffic"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

module "private_sg" {
  source = "./modules/security_groups"

  name        = "private-instance-security-group"
  description = "Security group for private instances"
  vpc_name    = module.vpc.vpc_name
  vpc_id      = module.vpc.vpc_id

  ingress_rules = [
    {
      description               = "Allow SSH from public security group"
      from_port                 = 22
      to_port                   = 22
      protocol                  = "tcp"
      referenced_security_group = module.public_sg.id
    }
  ]

  egress_rules = [
    {
      description = "Allow all outbound traffic"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

module "public_ec2" {
  source = "./modules/ec2"

  name                        = "public-instance"
  vpc_name                    = module.vpc.vpc_name
  ami_id                      = "ami-0f88e80871fd81e91"
  instance_type               = "t3.micro"
  subnet_id                   = module.vpc.public_subnet_id
  vpc_security_group_ids      = [module.public_sg.id]
  key_name                    = "ec2key"
  associate_public_ip_address = true
}

module "private_ec2" {
  source = "./modules/ec2"

  name                        = "private-instance"
  vpc_name                    = module.vpc.vpc_name
  ami_id                      = "ami-0f88e80871fd81e91"
  instance_type               = "t3.micro"
  subnet_id                   = module.vpc.private_subnet_id
  vpc_security_group_ids      = [module.private_sg.id]
  key_name                    = "ec2key"
  associate_public_ip_address = false
}
