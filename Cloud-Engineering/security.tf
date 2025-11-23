resource "aws_security_group" "public_sg" {
  name        = "public_sg"
  description = "Security group for public subnet"
  vpc_id      = aws_vpc.megazone_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.cidr_block
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.cidr_block
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.cidr_block
  }
  
  tags = {
    Name = "Public_SG"
  }
}
