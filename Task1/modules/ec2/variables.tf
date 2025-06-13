variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
  default     = "my-vpc"
}

variable "name" {
  description = "Name of the EC2 instance"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Key pair name for SSH access"
  type        = string
  default     = null
}

variable "subnet_id" {
  description = "Subnet ID for the EC2 instance"
  type        = string
}

variable "vpc_security_group_ids" {
  description = "List of security group IDs for the EC2 instance"
  type        = list(string)
}

variable "user_data" {
  description = "User data script for the EC2 instance"
  type        = string
  default     = null
}

variable "associate_public_ip_address" {
  description = "Associate a public IP address with the EC2 instance"
  type        = bool
  default     = false
}
