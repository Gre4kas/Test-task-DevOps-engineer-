output "environment_name" {
  description = "The name of the Elastic Beanstalk environment"
  value       = aws_elastic_beanstalk_environment.environment.name
}

output "environment_id" {
  description = "The ID of the Elastic Beanstalk environment"
  value       = aws_elastic_beanstalk_environment.environment.id
}

output "environment_endpoint_url" {
  description = "The endpoint URL of the Elastic Beanstalk environment"
  value       = aws_elastic_beanstalk_environment.environment.endpoint_url
}

output "database_endpoint" {
  description = "Endpoint of the managed database (if created)"
  value = try(
    tolist([for s in aws_elastic_beanstalk_environment.environment.setting : s.value if s.name == "Endpoint" && s.namespace == "aws:rds:dbinstance"])[0],
    null
  )
}

output "database_username" {
  description = "Database username"
  value = var.db_username # Outputting the variable for convenience, not the actual secret
}