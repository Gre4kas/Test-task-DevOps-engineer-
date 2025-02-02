module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.18.1"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs             = data.aws_availability_zones.available.names
  private_subnets = var.private_subnets_cidr
  public_subnets  = var.public_subnets_cidr

  enable_nat_gateway     = true
  single_nat_gateway     = true # For cost saving in dev/test, consider false for HA in prod
  enable_dns_hostnames   = true
  enable_dns_support     = true

  tags = var.vpc_tags

  public_subnet_tags = var.public_subnet_tags
  private_subnet_tags = var.private_subnet_tags
}

# Data source to get available availability zones in the region
data "aws_availability_zones" "available" {}


# Security Group for Elastic Beanstalk Instances (Web Tier)
resource "aws_security_group" "elastic_beanstalk_sg" {
  name        = var.elastic_beanstalk_sg_name
  description = "Security group for Elastic Beanstalk web tier instances"
  vpc_id      = module.vpc.vpc_id

  tags = var.elastic_beanstalk_sg_tags
}

# Ingress rule for HTTP traffic to Elastic Beanstalk instances
resource "aws_vpc_security_group_ingress_rule" "http_ingress_eb" {
  security_group_id = aws_security_group.elastic_beanstalk_sg.id
  cidr_ipv4         = "0.0.0.0/0" 
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
  description       = "Allow HTTP traffic"
}

# Ingress rule for HTTPS traffic to Elastic Beanstalk instances
resource "aws_vpc_security_group_ingress_rule" "https_ingress_eb" {
  security_group_id = aws_security_group.elastic_beanstalk_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
  description       = "Allow HTTPS traffic"
}

# Egress rule to allow all outbound traffic from Elastic Beanstalk instances
resource "aws_vpc_security_group_egress_rule" "all_egress_eb" {
  security_group_id = aws_security_group.elastic_beanstalk_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 0
  ip_protocol       = "-1" # All protocols
  to_port           = 0
  description       = "Allow all outbound traffic"
}
