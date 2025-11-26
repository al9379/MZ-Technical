variable "region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "azs" {
  description = "Availability Zones to use for the VPC"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "global_cidr_block" {
  description = "CIDR block for allowing general internet access"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "vpc_name" {
  description = "Name tag for the VPC"
  type        = string
  default     = "megazone_vpc"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private application subnets"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "database_subnet_cidrs" {
  description = "CIDR blocks for database subnets"
  type        = list(string)
  default     = ["10.0.151.0/24", "10.0.152.0/24"]
}

variable "ssh_allowed_ips" {
  description = "CIDR blocks allowed to access Bastion via SSH"
  type        = list(string)
  default = ["68.132.96.4/32"]
}
