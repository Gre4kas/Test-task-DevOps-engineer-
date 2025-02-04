provider "aws" {
  region = var.region
}

module "vpc" {
  source  = "cloudposse/vpc/aws"
  version = "2.1.0"

  ipv4_primary_cidr_block = "172.16.0.0/16"

  context = module.this.context
}

module "subnets" {
  source  = "cloudposse/dynamic-subnets/aws"
  version = "2.4.1"

  availability_zones   = var.availability_zones
  vpc_id               = module.vpc.vpc_id
  igw_id               = [module.vpc.igw_id]
  ipv4_enabled         = true
  ipv4_cidr_block      = [module.vpc.vpc_cidr_block]
  nat_gateway_enabled  = true
  nat_instance_enabled = false

  map_public_ip_on_launch = true
  
  context = module.this.context
}

module "elastic_beanstalk_application" {
  source  = "cloudposse/elastic-beanstalk-application/aws"
  version = "0.11.1"

  description = "Test Elastic Beanstalk application"

  context = module.this.context
}

module "elastic_beanstalk_environment" {
  source  = "cloudposse/elastic-beanstalk-environment/aws"
  version = "0.52.0"

  description                = var.description
  region                     = var.region
  availability_zone_selector = var.availability_zone_selector
  dns_zone_id                = var.dns_zone_id

  wait_for_ready_timeout             = var.wait_for_ready_timeout
  elastic_beanstalk_application_name = module.elastic_beanstalk_application.elastic_beanstalk_application_name
  environment_type                   = var.environment_type
  loadbalancer_type                  = var.loadbalancer_type
  elb_scheme                         = var.elb_scheme
  tier                               = var.tier
  version_label                      = var.version_label
  force_destroy                      = var.force_destroy

  instance_type    = var.instance_type
  root_volume_size = var.root_volume_size
  root_volume_type = var.root_volume_type

  autoscale_min             = var.autoscale_min
  autoscale_max             = var.autoscale_max
  autoscale_measure_name    = var.autoscale_measure_name
  autoscale_statistic       = var.autoscale_statistic
  autoscale_unit            = var.autoscale_unit
  autoscale_lower_bound     = var.autoscale_lower_bound
  autoscale_lower_increment = var.autoscale_lower_increment
  autoscale_upper_bound     = var.autoscale_upper_bound
  autoscale_upper_increment = var.autoscale_upper_increment

  vpc_id                              = module.vpc.vpc_id
  loadbalancer_subnets                = module.subnets.public_subnet_ids
  application_subnets                 = module.subnets.private_subnet_ids

  allow_all_egress = true
  associate_public_ip_address = false
  loadbalancer_redirect_http_to_https = false
  loadbalancer_ssl_policy = "ELBSecurityPolicy-2016-08"
  loadbalancer_certificate_arn = data.aws_acm_certificate.selected.arn

  additional_security_group_rules = [
    {
      type                     = "ingress"
      from_port                = 0
      to_port                  = 65535
      protocol                 = "-1"
      source_security_group_id = module.vpc.vpc_default_security_group_id
      description              = "Allow all inbound traffic from trusted Security Groups"
    }
  ]

  rolling_update_enabled  = var.rolling_update_enabled
  rolling_update_type     = var.rolling_update_type
  updating_min_in_service = var.updating_min_in_service
  updating_max_batch      = var.updating_max_batch

  healthcheck_url  = var.healthcheck_url
  application_port = var.application_port

  # https://docs.aws.amazon.com/elasticbeanstalk/latest/platforms/platforms-supported.html
  # https://docs.aws.amazon.com/elasticbeanstalk/latest/platforms/platforms-supported.html#platforms-supported.docker
  solution_stack_name = var.solution_stack_name

  additional_settings = var.additional_settings

  extended_ec2_policy_document = data.aws_iam_policy_document.minimal_s3_permissions.json
  prefer_legacy_ssm_policy     = false
  prefer_legacy_service_policy = false
  scheduled_actions            = var.scheduled_actions

  s3_bucket_versioning_enabled = var.s3_bucket_versioning_enabled
  enable_loadbalancer_logs     = var.enable_loadbalancer_logs

  context = module.this.context

  depends_on = [module.rds_db]
}

data "aws_iam_policy_document" "minimal_s3_permissions" {
  statement {
    sid = "AllowS3OperationsOnElasticBeanstalkBuckets"
    actions = [
      "s3:ListAllMyBuckets",
      "s3:GetBucketLocation"
    ]
    resources = ["*"]
  }
}

module "ecr_repo" {
  source = "../../modules/ecr"

  repository_name        = var.ecr_repository_name
  image_tag_mutability   = "MUTABLE" # For dev, mutable tags are often okay
  scan_on_push           = true
  tags = {
    Environment = "Dev"
    Project     = "WebApp"
    Terraform   = "true"
  }
}

data "aws_acm_certificate" "selected" {
  domain   = var.acm_certificate_domain # Use a variable for the domain name
  statuses = ["ISSUED"] # Only fetch issued certificates (optional, but good practice)
}

module "rds_db" { # You can name the module instance as 'rds_db' or anything you like
  source  = "../../modules/rds" # Assuming your 'test' directory is at the same level as 'modules'

  db_instance_identifier = var.db_instance_identifier
  db_name                 = var.db_name
  db_username             = var.db_username
  db_password             = var.db_password
  db_instance_class       = var.db_instance_class
  db_allocated_storage    = var.db_allocated_storage
  db_engine_version       = var.db_engine_version
  db_multi_az             = var.db_multi_az
  db_security_group_id    = module.vpc.vpc_default_security_group_id
  db_subnet_ids           = module.subnets.private_subnet_ids
  db_deletion_protection  = var.db_deletion_protection
  db_storage_encrypted = false
  major_engine_version = var.major_engine_version

  tags                    = var.tags

  # Derive 'family' from 'db_engine_version' - adjust logic if needed for other versions
  family = "mysql8" 
}