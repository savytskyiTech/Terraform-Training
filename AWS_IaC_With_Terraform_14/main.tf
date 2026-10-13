provider "aws" {
  region = var.aws_region

  default_tags {
    tags = local.common_tags
  }
}

locals {
  common_tags = {
    Terraform = "true"
    Project   = var.project_id
  }
}

module "network" {
  source = "./modules/network"

  vpc_name         = "${var.project_id}-vpc"
  vpc_cidr         = var.vpc_cidr
  public_subnets   = var.public_subnets
  gateway_name     = "${var.project_id}-igw"
  route_table_name = "${var.project_id}-rt"
  tags             = local.common_tags
}

module "network_security" {
  source = "./modules/network_security"

  vpc_id           = module.network.vpc_id
  allowed_ip_range = var.allowed_ip_range
  security_group_names = {
    ssh          = "${var.project_id}-ssh-sg"
    public_http  = "${var.project_id}-public-http-sg"
    private_http = "${var.project_id}-private-http-sg"
  }
  tags = local.common_tags
}

module "application" {
  source = "./modules/application"

  vpc_id             = module.network.vpc_id
  subnet_ids         = module.network.subnet_ids
  security_group_ids = module.network_security.security_group_ids
  ami_name_pattern   = var.ami_name_pattern
  instance_type      = var.instance_type
  desired_capacity   = var.desired_capacity
  min_size           = var.min_size
  max_size           = var.max_size
  resource_names = {
    launch_template = "${var.project_id}-template"
    autoscaling     = "${var.project_id}-asg"
    load_balancer   = "${var.project_id}-lb"
    target_group    = "${var.project_id}-tg"
    instance        = "${var.project_id}-instance"
  }
  tags = local.common_tags
}
