output "db_instance_endpoint" {
  description = "Endpoint of the RDS instance"
  value       = module.rds_instance.db_instance_address
}

output "db_instance_port" {
  description = "Port of the RDS instance"
  value       = module.rds_instance.db_instance_port
}

output "db_instance_username" {
  description = "Database username"
  value       = module.rds_instance.db_instance_username
  sensitive   = true
}
