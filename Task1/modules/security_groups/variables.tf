variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

variable "name" {
  description = "Name of the security group"
  type        = string
}

variable "description" {
  description = "Description of the security group"
  type        = string
  default     = "Managed by Terraform"
}

variable "vpc_id" {
  description = "ID of the VPC where to create security group"
  type        = string
}

variable "ingress_rules" {
  description = "List of ingress rules"
  type        = list(object({
    description               = string
    from_port                 = number
    to_port                   = number
    protocol                  = string
    cidr_blocks               = optional(list(string), [])
    referenced_security_group = optional(string)
  }))
}

variable "egress_rules" {
  description = "List of egress"
  type        = list(object({
    description               = string
    from_port                 = number
    to_port                   = number
    protocol                  = string
    cidr_blocks               = optional(list(string), [])
    referenced_security_group = optional(string)
  }))
  default = [{
    description      = "Allow all outbound traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }]
}