resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.megazone_vpc.id

  route{
    cidr_block = var.global_cidr_block
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Public_Route_Table"
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.megazone_vpc.id

  route{
    cidr_block = var.global_cidr_block
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
