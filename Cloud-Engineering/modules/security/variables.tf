variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "global_cidr_block" {
  description = "CIDR block for allowing general internet access"
  type        = list(string)
}

variable "ssh_allowed_ips" {
  description = "CIDR blocks allowed to access Bastion via SSH"
  type        = list(string)
}

variable "database_subnet_cidrs" {
  description = "CIDR blocks for database subnets"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private application subnets"
  type        = list(string)
}

variable "public_subnet_ids" {
  description = "IDs of public subnets for NACLs"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "IDs of private subnets for NACLs"
  type        = list(string)
}

variable "database_subnet_ids" {
  description = "IDs of database subnets for NACLs"
  type        = list(string)
}
