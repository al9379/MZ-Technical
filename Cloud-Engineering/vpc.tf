#VPC Creation
resource "aws_vpc" "megazone_vpc" {
  cidr_block = var.cidr
  tags = {
    Name = "Megazone_VPC"
  }
}

#Public Subnet
resource "aws_subnet" "public_subnets" {
  count             = length(var.azs)
  vpc_id            = aws_vpc.megazone_vpc.id
  cidr_block       = var.public_subnet_cidrs[count.index]
  availability_zone = var.azs[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "Public_Subnet_${count.index + 1}"
  }
}

#Private Subnet
resource aws_subnet "private_subnets" {
  count             = length(var.azs)
  vpc_id            = aws_vpc.megazone_vpc.id
  cidr_block       = var.private_subnet_cidrs[count.index]
  availability_zone = var.azs[count.index]

  tags = {
    Name = "Private_Subnet_${count.index + 1}"
  }
}

#Private Database Subnet
resource aws_subnet "database_subnets" {
  count             = length(var.azs)
  vpc_id            = aws_vpc.megazone_vpc.id
  cidr_block       = var.database_subnet_cidrs[count.index]
  availability_zone = var.azs[count.index]

  tags = {
    Name = "Database_Subnet_${count.index + 1}"
  }
} 

#Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.megazone_vpc.id

  tags = {
    Name = "Megazone_IGW"
  }
}

#NAT Gateway
resource "aws_eip" "nat_eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnets[0].id

  tags = {
    Name = "Nat_Gateway"
  }
}

