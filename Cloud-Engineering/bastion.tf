#EC2 Bastion Host Configuration
resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.public_subnets[0].id
  vpc_security_group_ids      = [aws_security_group.bastion_sg.id]
  associate_public_ip_address = true

  key_name = "megazone-bastion-key"

  iam_instance_profile = aws_iam_instance_profile.bastion_ssm_profile.name

  tags = {
    Name = "Bastion-Host"
  }
}

#Find the latest Amazon Linux 2023 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-kernel-*"]
  }
}

#Allow access through SSM to the bastion host
resource "aws_iam_role" "bastion_ssm_role" {
  name = "bastion_ssm_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

#Attach the AmazonSSMManagedInstanceCore policy to the role
resource "aws_iam_role_policy_attachment" "bastion_ssm_attach" {
  role       = aws_iam_role.bastion_ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

#Create an instance profile for the bastion host
resource "aws_iam_instance_profile" "bastion_ssm_profile" {
  name = "bastion_ssm_profile"
  role = aws_iam_role.bastion_ssm_role.name
}

# Create an Elastic IP for the Bastion host
resource "aws_eip" "bastion_eip" {
  instance   = aws_instance.bastion.id
  domain     = "vpc"
  depends_on = [aws_instance.bastion]

  tags = {
    Name = "Bastion-EIP"
  }
}
