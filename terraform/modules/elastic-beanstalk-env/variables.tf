variable "environment_name" {
  type        = string
  description = "The name of the Elastic Beanstalk environment"
}

variable "application_name" {
  type        = string
  description = "The name of the Elastic Beanstalk application (from app module)"
}

variable "solution_stack_name" {
  type        = string
  description = "The Elastic Beanstalk solution stack name (e.g., Docker platform)"
  default     = "64bit Amazon Linux 2 v5.6.7 running Docker" # Example, update as needed
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type for the environment"
  default     = "t2.micro" # Good default for dev/testing
}

variable "min_instances" {
  type        = number
  description = "Minimum number of instances in the Auto Scaling group"
  default     = 1
}

variable "max_instances" {
  type        = number
  description = "Maximum number of instances in the Auto Scaling group"
  default     = 1 # For dev, consider increasing for staging/prod
}

variable "service_role_arn" {
  type        = string
  description = "ARN of the Elastic Beanstalk Service Role (from iam-roles module)"
}

variable "instance_profile_arn" {
  type        = string
  description = "ARN of the Elastic Beanstalk EC2 Instance Profile (from iam-roles module)"
}

variable "docker_image" {
  type        = string
  description = "Docker image to deploy (e.g., ECR repository URL + tag)"
  # Example:  "public.ecr.aws/your-account-id/your-repo:latest"
}

variable "container_port" {
  type        = number
  description = "Container port your application listens on"
  default     = 80
}

variable "host_port" {
  type        = number
  description = "Host port to map to the container port (usually same as container port)"
  default     = 80
}

variable "environment_variables" {
  type        = map(string)
  description = "Map of environment variables to pass to the application"
  default     = {}
}

# Database Variables (for in-environment PostgreSQL)
variable "db_username" {
  type        = string
  description = "Username for the managed PostgreSQL database"
  default     = "admin" # Change in production!
}

variable "db_password" {
  type        = string
  description = "Password for the managed PostgreSQL database"
  sensitive   = true # Mark as sensitive
  default     = "password" # Change and secure in production! Consider secrets management
}

variable "db_instance_class" {
  type        = string
  description = "Instance class for the managed PostgreSQL database"
  default     = "db.t2.micro" # Good for dev, consider larger for staging/prod
}

variable "db_allocated_storage" {
  type        = number
  description = "Allocated storage (GB) for the managed PostgreSQL database"
  default     = 5 # Minimum, adjust as needed
}

variable "db_engine_version" {
  type        = string
  description = "Version of PostgreSQL engine"
  default     = "14.6" # Example, choose a supported version
}

variable "tags" {
  type        = map(string)
  description = "Optional tags to apply to the Elastic Beanstalk environment"
  default     = {}
}

variable "ec2_key_name" {
  type        = string
  description = "EC2 Key Pair to associate with EC2 instances for SSH access (optional)"
  default     = "" # Empty by default, set to your key pair name if needed
}

variable "enable_rolling_updates" {
  type        = bool
  description = "Enable rolling updates for deployments"
  default     = true # Recommended for minimal downtime
}

variable "application_healthcheck_url" {
  type        = string
  description = "URL for the application health check (defaults to health_check_path)"
  default     = null # Will default to health_check_path if null
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where Elastic Beanstalk environment will be created (from network module)"
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "List of public subnet IDs for Elastic Beanstalk environment (from network module)"
}

variable "elastic_beanstalk_sg_id" {
  type        = string
  description = "Security Group ID for Elastic Beanstalk instances (from network module)"
}

variable "ssl_certificate_arn" {
  type        = string
  description = "ARN of the SSL Certificate from AWS Certificate Manager (ACM) for HTTPS"
  # You MUST provide a valid ACM certificate ARN for HTTPS to work
}