variable "public_subnet_id" {
  description = "ID of the public subnet to launch the bastion in"
  type        = string
}

variable "bastion_sg_id" {
  description = "Security Group ID for the Bastion host"
  type        = string
}

variable "key_name" {
  description = "Name of the SSH key pair"
  type        = string
  default     = "megazone-bastion-key"
}
