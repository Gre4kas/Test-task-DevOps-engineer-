terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" # Or the version you prefer
    }
  }
}

provider "aws" {
  region = "us-east-1" # Replace with your desired AWS region
}

# Configure backend for remote state storage
# terraform {
#   backend "s3" {
#     bucket         = "your-terraform-state-bucket-name" # Replace with your S3 bucket name for state
#     key            = "eb-docker-app/dev/terraform.tfstate" # Path within the bucket
#     region         = "us-east-1" # Should match your provider region
#     dynamodb_table = "terraform-state-lock-dynamodb-table" # Replace with your DynamoDB table name for locking
#     encrypt        = true
#   }
# }

# ---------------------------------------------------------------------------------------------------------------------
# IAM Roles Module
# ---------------------------------------------------------------------------------------------------------------------
module "iam_roles" {
  source = "../../modules/iam-roles"
  # You can customize role names if needed, or use defaults
}

# ---------------------------------------------------------------------------------------------------------------------
# ECR Repository Module
# ---------------------------------------------------------------------------------------------------------------------
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

# ---------------------------------------------------------------------------------------------------------------------
# Elastic Beanstalk Application Module
# ---------------------------------------------------------------------------------------------------------------------
module "eb_app" {
  source = "../../modules/elastic-beanstalk-app"

  application_name        = var.application_name
  application_description = "Development environment application for ${var.application_name}"
}

# ---------------------------------------------------------------------------------------------------------------------
# Networking Module (VPC, Subnets, Security Group)
# ---------------------------------------------------------------------------------------------------------------------
module "network" {
  source = "../../modules/networking"

  vpc_name = "${var.environment_name}-vpc"
  vpc_cidr = "10.0.0.0/16" # You can customize CIDR blocks in variables.tf or terraform.tfvars if needed

  vpc_tags = {
    Name        = "${var.environment_name}-vpc"
    Environment = "Dev"
    Project     = "WebApp"
    Terraform   = "true"
  }

  elastic_beanstalk_sg_tags = {
    Name        = "${var.environment_name}-eb-sg"
    Environment = "Dev"
    Project     = "WebApp"
    Terraform   = "true"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# Data Source to Fetch ACM Certificate ARN
# ---------------------------------------------------------------------------------------------------------------------
data "aws_acm_certificate" "selected" {
  domain   = var.acm_certificate_domain # Use a variable for the domain name
  statuses = ["ISSUED"] # Only fetch issued certificates (optional, but good practice)
}

# ---------------------------------------------------------------------------------------------------------------------
# Elastic Beanstalk Environment Module
# ---------------------------------------------------------------------------------------------------------------------
module "eb_env" {
  source = "../../modules/elastic-beanstalk-env"

  environment_name = var.environment_name
  application_name = module.eb_app.application_name # From eb_app module output

  solution_stack_name = "64bit Amazon Linux 2 v4.0.7 running Docker" # Ensure this is a current Docker platform version

  instance_type         = "t2.micro"
  min_instances         = 1
  max_instances         = 1

  service_role_arn    = module.iam_roles.service_role_arn   # From iam_roles module output
  instance_profile_arn = module.iam_roles.instance_profile_arn # From iam_roles module output

  ssl_certificate_arn = data.aws_acm_certificate.selected.arn

  docker_image = var.docker_image # From ecr_repo module output, using 'latest' tag initially

  container_port = 80
  host_port      = 80

  environment_variables = {
    "ENVIRONMENT" = "development" # Example environment variable
  }

  db_username         = "devuser" # **IMPORTANT: Change for staging/prod and use secrets management!**
  db_password         = "devpassword" # **IMPORTANT: Change for staging/prod and use secrets management!**
  db_instance_class   = "db.t2.micro"
  db_allocated_storage = 5
  db_engine_version   = "14.6" # Example, choose a supported version

  tags = {
    Environment = "Dev"
    Project     = "WebApp"
    Terraform   = "true"
  }

  depends_on = [module.network] # Explicit dependency on network module
  
  # Pass network module outputs as variables to eb_env module
  vpc_id                 = module.network.vpc_id
  public_subnet_ids      = module.network.public_subnet_ids
  elastic_beanstalk_sg_id = module.network.elastic_beanstalk_sg_id
}