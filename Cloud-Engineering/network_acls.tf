############################################
# PUBLIC SUBNET NACL
############################################
resource "aws_network_acl" "public_nacl" {
  vpc_id     = aws_vpc.megazone_vpc.id
  subnet_ids = aws_subnet.public_subnets[*].id

  tags = {
    Name = "Public-NACL"
  }
}

# Inbound HTTP (80)
resource "aws_network_acl_rule" "public_ingress_http" {
  network_acl_id = aws_network_acl.public_nacl.id
  rule_number    = 100
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 80
  to_port        = 80
}

# Inbound HTTPS (443)
resource "aws_network_acl_rule" "public_ingress_https" {
  network_acl_id = aws_network_acl.public_nacl.id
  rule_number    = 110
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 443
  to_port        = 443
}

# Inbound SSH (22) for Bastion access
resource "aws_network_acl_rule" "public_ingress_ssh" {
  network_acl_id = aws_network_acl.public_nacl.id
  rule_number    = 120
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 22
  to_port        = 22
}

# Outbound ephemeral ports
resource "aws_network_acl_rule" "public_egress_ephemeral" {
  network_acl_id = aws_network_acl.public_nacl.id
  rule_number    = 100
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 1024
  to_port        = 65535
}

# Outbound HTTPS for ALB to reach internet
resource "aws_network_acl_rule" "public_egress_https" {
  network_acl_id = aws_network_acl.public_nacl.id
  rule_number    = 110
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 443
  to_port        = 443
}



############################################
# PRIVATE APP SUBNET NACL
############################################
resource "aws_network_acl" "app_nacl" {
  vpc_id     = aws_vpc.megazone_vpc.id
  subnet_ids = aws_subnet.private_subnets[*].id

  tags = {
    Name = "App-NACL"
  }
}

# Allow ALB (in public subnets) → App on port 80 (HTTP)
# ALB terminates HTTPS (443) and forwards HTTP (80) to app tier
resource "aws_network_acl_rule" "app_ingress_http_from_public" {
  network_acl_id = aws_network_acl.app_nacl.id
  rule_number    = 100
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "10.0.0.0/16"   # Allow from public subnets (ALB)
  from_port      = 80
  to_port        = 80
}

# Allow SSH from Bastion (public subnet)
resource "aws_network_acl_rule" "app_ingress_ssh_from_public" {
  network_acl_id = aws_network_acl.app_nacl.id
  rule_number    = 110
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = var.public_subnet_cidrs[0]   # Bastion lives in subnet 0
  from_port      = 22
  to_port        = 22
}

# Outbound to Database tier on MySQL port
resource "aws_network_acl_rule" "app_egress_mysql" {
  network_acl_id = aws_network_acl.app_nacl.id
  rule_number    = 100
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "10.0.0.0/16"   # Database subnets
  from_port      = 3306
  to_port        = 3306
}

# Outbound HTTPS for app updates via NAT Gateway
resource "aws_network_acl_rule" "app_egress_https" {
  network_acl_id = aws_network_acl.app_nacl.id
  rule_number    = 110
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 443
  to_port        = 443
}

# Outbound ephemeral for App → ALB/db responses
resource "aws_network_acl_rule" "app_egress_ephemeral" {
  network_acl_id = aws_network_acl.app_nacl.id
  rule_number    = 120
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "10.0.0.0/16"
  from_port      = 1024
  to_port        = 65535
}



############################################
# DATABASE SUBNET NACL
############################################
resource "aws_network_acl" "db_nacl" {
  vpc_id     = aws_vpc.megazone_vpc.id
  subnet_ids = aws_subnet.database_subnets[*].id

  tags = {
    Name = "Database-NACL"
  }
}

# Allow App → DB on port 3306 from all app subnets
resource "aws_network_acl_rule" "db_ingress_mysql_from_app_1" {
  network_acl_id = aws_network_acl.db_nacl.id
  rule_number    = 100
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = var.private_subnet_cidrs[0]  # App subnet AZ-1
  from_port      = 3306
  to_port        = 3306
}

resource "aws_network_acl_rule" "db_ingress_mysql_from_app_2" {
  network_acl_id = aws_network_acl.db_nacl.id
  rule_number    = 110
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = var.private_subnet_cidrs[1]  # App subnet AZ-2
  from_port      = 3306
  to_port        = 3306
}

# DB outbound ephemeral for responses to all app subnets
resource "aws_network_acl_rule" "db_egress_ephemeral_to_app_1" {
  network_acl_id = aws_network_acl.db_nacl.id
  rule_number    = 100
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = var.private_subnet_cidrs[0]
  from_port      = 1024
  to_port        = 65535
}

resource "aws_network_acl_rule" "db_egress_ephemeral_to_app_2" {
  network_acl_id = aws_network_acl.db_nacl.id
  rule_number    = 110
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = var.private_subnet_cidrs[1]
  from_port      = 1024
  to_port        = 65535
}
