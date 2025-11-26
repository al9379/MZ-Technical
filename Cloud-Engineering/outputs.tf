output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.megazone_vpc.id
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = aws_subnet.public_subnets[*].id
}

output "private_subnet_ids" {
  description = "List of private app subnet IDs"
  value       = aws_subnet.private_subnets[*].id
}

output "database_subnet_ids" {
  description = "List of database subnet IDs"
  value       = aws_subnet.database_subnets[*].id
}

output "nat_gateway_id" {
  description = "NAT Gateway ID"
  value       = aws_nat_gateway.nat_gateway.id
}

output "bastion_sg_id" {
  description = "Security group ID of bastion"
  value       = aws_security_group.bastion_sg.id
}

output "app_sg_id" {
  description = "Security group ID of app servers"
  value       = aws_security_group.app_sg.id
}

output "database_sg_id" {
  description = "Security group ID of database servers"
  value       = aws_security_group.database_sg.id
}

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.application_load_balancer.dns_name
}

output "alb_arn" {
  description = "ARN of the ALB"
  value       = aws_lb.application_load_balancer.arn
}

output "bastion_public_ip" {
  description = "Public IP of the bastion host"
  value       = aws_eip.bastion_eip.public_ip
}

output "bastion_instance_id" {
  description = "EC2 instance ID of the bastion host"
  value       = aws_instance.bastion.id
}
