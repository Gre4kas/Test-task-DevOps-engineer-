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

output "db_instance_password" {
  description = "Database password"
  value       = module.rds_instance.db_instance_password
  sensitive   = true
}

output "db_instance_id" {
  description = "RDS instance ID"
  value       = module.rds_instance.db_instance_id
}

output "db_security_group_id" {
  description = "Security Group ID of the RDS instance"
  value       = module.rds_instance.db_instance_security_group_id
}

output "db_instance_endpoint" {
  description = "Endpoint of the RDS instance"
  value       = module.rds_instance.db_instance_address
}