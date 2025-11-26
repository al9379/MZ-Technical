module "vpc" {
  source = "./modules/vpc"

  vpc_cidr              = var.vpc_cidr
  public_subnet_cidrs   = var.public_subnet_cidrs
  private_subnet_cidrs  = var.private_subnet_cidrs
  database_subnet_cidrs = var.database_subnet_cidrs
  azs                   = var.azs
}

module "security" {
  source = "./modules/security"

  vpc_id                = module.vpc.vpc_id
  global_cidr_block     = var.global_cidr_block
  ssh_allowed_ips       = var.ssh_allowed_ips
  database_subnet_cidrs = var.database_subnet_cidrs
  public_subnet_cidrs   = var.public_subnet_cidrs
  private_subnet_cidrs  = var.private_subnet_cidrs
  public_subnet_ids     = module.vpc.public_subnet_ids
  private_subnet_ids    = module.vpc.private_subnet_ids
  database_subnet_ids   = module.vpc.database_subnet_ids
}

module "alb" {
  source = "./modules/alb"

  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  alb_sg_id         = module.security.alb_sg_id
}

module "compute" {
  source = "./modules/compute"

  public_subnet_id = module.vpc.public_subnet_ids[0]
  bastion_sg_id    = module.security.bastion_sg_id
  key_name         = "megazone-bastion-key"
}
