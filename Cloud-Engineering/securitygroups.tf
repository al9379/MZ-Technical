resource "aws_security_group" "alb_sg" {
  name        = "alb_sg"
  description = "Allow traffic to ALB"
  vpc_id      = aws_vpc.megazone_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.global_cidr_block
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.global_cidr_block
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.global_cidr_block
  }

  tags = {
    Name = "ALB_SG"
  }
}

resource "aws_security_group" "bastion_sg" {
  name        = "bastion_sg"
  description = "Allow SSH access to bastion host"
  vpc_id      = aws_vpc.megazone_vpc.id

  ingress {
    description = "SSH from allowed IPs"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.ssh_allowed_ips
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.global_cidr_block
  }

  tags = {
    Name = "Bastion_SG"
  }
}

resource "aws_security_group" "app_sg" {
  name        = "app_sg"
  description = "Security group for application servers"
  vpc_id      = aws_vpc.megazone_vpc.id

  ingress {
    description     = "HTTP from ALB (ALB terminates HTTPS)"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  ingress {
    description     = "SSH from Bastion"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }

  egress {
    description = "Allow all outbound for app updates and database access"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.global_cidr_block
  }

  tags = {
    Name = "App_SG"
  }
}

resource "aws_security_group" "database_sg" {
  name        = "database_sg"
  description = "Security group for database subnet"
  vpc_id      = aws_vpc.megazone_vpc.id

  ingress {
    description     = "MySQL from App tier"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.app_sg.id]
  }

  egress {
    description = "Allow responses to App tier only"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.private_subnet_cidrs
  }

  tags = {
    Name = "Database_SG"
  }
}

