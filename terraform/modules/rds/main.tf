module "rds_instance" {
  source  = "terraform-aws-modules/rds/aws"
  version = "6.10.0"

  identifier = var.db_instance_identifier

  family = var.family
  engine         = "mysql"
  engine_version = var.db_engine_version
  instance_class = var.db_instance_class
  allocated_storage = var.db_allocated_storage
  storage_encrypted = var.db_storage_encrypted # Control storage encryption using the variable
  major_engine_version = var.major_engine_version
  
  db_name   = var.db_name
  username  = var.db_username
  password  = var.db_password # Consider secrets management for production

  port = 3306 # Default MySQL port

  multi_az               = var.db_multi_az # For production, set to true
  vpc_security_group_ids = [var.db_security_group_id] # Security group for RDS

  subnet_ids = var.db_subnet_ids # Private subnets for RDS

  publicly_accessible = false # RDS should be in private subnets and not publicly accessible

  backup_retention_period = 7 # Days, adjust as needed
  maintenance_window    = "Mon:09:00-Mon:10:00" # Example maintenance window, adjust as needed
  backup_window           = "07:00-09:00" # Example backup window, adjust as needed

  enabled_cloudwatch_logs_exports = ["general", "error", "slowquery"] # MySQL log types (adjust as needed)

  performance_insights_enabled         = true
  performance_insights_retention_period = 7 # Days, adjust as needed

  deletion_protection = var.db_deletion_protection # Enable for production to prevent accidental deletion

  tags = var.tags
}