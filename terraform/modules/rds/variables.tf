variable "db_instance_identifier" {
  type        = string
  description = "Identifier for the RDS instance"
}

variable "db_name" {
  type        = string
  description = "Name of the initial database"
  default     = "mydb"
}

variable "db_username" {
  type        = string
  description = "Username for the RDS database"
  default     = "dbadmin" # Change in production!
}

variable "db_password" {
  type        = string
  description = "Password for the RDS database"
  sensitive   = true # Mark as sensitive
  # No default value, must be provided
}

variable "db_instance_class" {
  type        = string
  description = "Instance class for the RDS database"
  default     = "db.t2.micro" # Good for dev, consider larger for staging/prod
}

variable "db_allocated_storage" {
  type        = number
  description = "Allocated storage (GB) for the RDS database"
  default     = 20 # Adjust as needed
}

variable "db_engine_version" {
  type        = string
  description = "Version of PostgreSQL engine"
  default     = "14.6" # Example, choose a supported version
}

variable "db_multi_az" {
  type        = bool
  description = "Enable Multi-AZ deployment for high availability"
  default     = false # For dev, set to true for production
}

variable "db_security_group_id" {
  type        = string
  description = "Security Group ID for the RDS instance"
}

variable "db_subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs for the RDS instance (private subnets)"
}

variable "db_deletion_protection" {
  type        = bool
  description = "Enable deletion protection for the RDS instance"
  default     = false # Disable for dev to allow easy deletion, enable for production
}

variable "tags" {
  type        = map(string)
  description = "Optional tags to apply to the RDS instance"
  default     = {}
}