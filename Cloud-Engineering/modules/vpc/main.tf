# VPC Creation
resource "aws_vpc" "megazone_vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "Megazone_VPC"
  }
}

# Public Subnet
resource "aws_subnet" "public_subnets" {
  count             = length(var.azs)
  vpc_id            = aws_vpc.megazone_vpc.id
  cidr_block        = var.public_subnet_cidrs[count.index]
  availability_zone = var.azs[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "Public_Subnet_${count.index + 1}"
  }
}

# Private Subnet
resource "aws_subnet" "private_subnets" {
  count             = length(var.azs)
  vpc_id            = aws_vpc.megazone_vpc.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.azs[count.index]

  tags = {
    Name = "Private_Subnet_${count.index + 1}"
  }
}

# Private Database Subnet
resource "aws_subnet" "database_subnets" {
  count             = length(var.azs)
  vpc_id            = aws_vpc.megazone_vpc.id
  cidr_block        = var.database_subnet_cidrs[count.index]
  availability_zone = var.azs[count.index]

  tags = {
    Name = "Database_Subnet_${count.index + 1}"
  }
} 

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.megazone_vpc.id

  tags = {
    Name = "Megazone_IGW"
  }
}

# Create an Elastic IP for the NAT Gateway
resource "aws_eip" "nat_eip" {
  domain = "vpc"
}

# NAT Gateway Configuration
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnets[0].id

  tags = {
    Name = "Nat_Gateway"
  }
}

# --- Routing ---

# Define route tables for public, private, and database subnets
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.megazone_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Public_Route_Table"
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.megazone_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }
  tags = {
    Name = "Private_Route_Table"
  }
}

resource "aws_route_table" "database_route_table" {
  vpc_id = aws_vpc.megazone_vpc.id
  tags = {
    Name = "Database_Route_Table"
  }
}

# Associate route tables with subnets
resource "aws_route_table_association" "public_route_table_association" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "private_route_table_association" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "database_route_table_association" {
  count          = length(var.database_subnet_cidrs)
  subnet_id      = aws_subnet.database_subnets[count.index].id
  route_table_id = aws_route_table.database_route_table.id
}

