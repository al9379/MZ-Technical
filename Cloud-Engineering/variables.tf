variable "azs" {
  description = "Availability Zones to use for the VPC"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "cidr"{
    default = "10.0.0.0/16"
}

variable "global_cidr_block" {
    default = ["0.0.0.0/0"]
}

variable "name"{
    default = "megazone_vpc"
}

variable public_subnet_cidrs {
  description = "List of public subnet CIDR blocks"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable private_subnet_cidrs {
  description = "List of private subnet CIDR blocks"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable database_subnet_cidrs {
  description = "List of database subnet CIDR blocks"
  type        = list(string)
  default     = ["10.0.151.0/24", "10.0.152.0/24"]
}

variable ssh_allowed_ips {
  description = "CIDR blocks allowed to access via SSH"
  type        = list(string)
  default     = ["68.132.96.4/32"]
}