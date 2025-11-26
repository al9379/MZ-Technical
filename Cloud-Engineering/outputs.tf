output "alb_dns_name" {
  value = module.alb.alb_dns_name
}

output "bastion_public_ip" {
  value = module.compute.bastion_public_ip
}
