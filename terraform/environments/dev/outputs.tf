output "application_name" {
  description = "Name of the Elastic Beanstalk Application"
  value       = module.eb_app.application_name
}

output "environment_name" {
  description = "Name of the Elastic Beanstalk Environment"
  value       = module.eb_env.environment_name
}

output "environment_endpoint_url" {
  description = "URL of the Elastic Beanstalk Environment"
  value       = module.eb_env.environment_endpoint_url
}

output "ecr_repository_url" {
  description = "ECR Repository URL"
  value       = module.ecr_repo.repository_url
}

output "vpc_id" {
  description = "VPC ID"
  value       = module.network.vpc_id
}

output "public_subnet_ids" {
  description = "List of Public Subnet IDs"
  value       = module.network.public_subnet_ids
}

output "private_subnet_ids" {
  description = "List of Private Subnet IDs"
  value       = module.network.private_subnet_ids
}

output "elastic_beanstalk_sg_id" {
  description = "Elastic Beanstalk Security Group ID"
  value       = module.network.elastic_beanstalk_sg_id
}

output "database_endpoint" {
  description = "Database Endpoint (if managed DB is created)"
  value       = module.eb_env.database_endpoint
}

output "database_username" {
  description = "Database Username"
  value       = module.eb_env.database_username
}