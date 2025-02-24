variable "region" {
  type        = string
  description = "AWS region"
}

variable "availability_zones" {
  type        = list(string)
  description = "List of availability zones"
}

variable "description" {
  type        = string
  description = "Short description of the Environment"
}

variable "environment_type" {
  type        = string
  description = "Environment type, e.g. 'LoadBalanced' or 'SingleInstance'.  If setting to 'SingleInstance', `rolling_update_type` must be set to 'Time', `updating_min_in_service` must be set to 0, and `loadbalancer_subnets` will be unused (it applies to the ELB, which does not exist in SingleInstance environments)"
}

variable "loadbalancer_type" {
  type        = string
  description = "Load Balancer type, e.g. 'application' or 'classic'"
}

variable "dns_zone_id" {
  type        = string
  description = "Route53 parent zone ID. The module will create sub-domain DNS record in the parent zone for the EB environment"
}

variable "availability_zone_selector" {
  type        = string
  description = "Availability Zone selector"
}

variable "instance_type" {
  type        = string
  description = "Instances type"
}

variable "autoscale_min" {
  type        = number
  description = "Minumum instances to launch"
}

variable "autoscale_max" {
  type        = number
  description = "Maximum instances to launch"
}

variable "solution_stack_name" {
  type        = string
  description = "Elastic Beanstalk stack, e.g. Docker, Go, Node, Java, IIS. For more info, see https://docs.aws.amazon.com/elasticbeanstalk/latest/platforms/platforms-supported.html"
}

variable "wait_for_ready_timeout" {
  type        = string
  description = "The maximum duration to wait for the Elastic Beanstalk Environment to be in a ready state before timing out"
}

variable "tier" {
  type        = string
  description = "Elastic Beanstalk Environment tier, e.g. 'WebServer' or 'Worker'"
}

variable "version_label" {
  type        = string
  description = "Elastic Beanstalk Application version to deploy"
}

variable "force_destroy" {
  type        = bool
  description = "Force destroy the S3 bucket for load balancer logs"
}

variable "rolling_update_enabled" {
  type        = bool
  description = "Whether to enable rolling update"
}

variable "rolling_update_type" {
  type        = string
  description = "`Health` or `Immutable`. Set it to `Immutable` to apply the configuration change to a fresh group of instances"
}

variable "updating_min_in_service" {
  type        = number
  description = "Minimum number of instances in service during update"
}

variable "updating_max_batch" {
  type        = number
  description = "Maximum number of instances to update at once"
}

variable "healthcheck_url" {
  type        = string
  description = "Application Health Check URL. Elastic Beanstalk will call this URL to check the health of the application running on EC2 instances"
}

variable "application_port" {
  type        = number
  description = "Port application is listening on"
}

variable "root_volume_size" {
  type        = number
  description = "The size of the EBS root volume"
}

variable "root_volume_type" {
  type        = string
  description = "The type of the EBS root volume"
}

variable "autoscale_measure_name" {
  type        = string
  description = "Metric used for your Auto Scaling trigger"
}

variable "autoscale_statistic" {
  type        = string
  description = "Statistic the trigger should use, such as Average"
}

variable "autoscale_unit" {
  type        = string
  description = "Unit for the trigger measurement, such as Bytes"
}

variable "autoscale_lower_bound" {
  type        = number
  description = "Minimum level of autoscale metric to remove an instance"
}

variable "autoscale_lower_increment" {
  type        = number
  description = "How many Amazon EC2 instances to remove when performing a scaling activity."
}

variable "autoscale_upper_bound" {
  type        = number
  description = "Maximum level of autoscale metric to add an instance"
}

variable "autoscale_upper_increment" {
  type        = number
  description = "How many Amazon EC2 instances to add when performing a scaling activity"
}

variable "elb_scheme" {
  type        = string
  description = "Specify `internal` if you want to create an internal load balancer in your Amazon VPC so that your Elastic Beanstalk application cannot be accessed from outside your Amazon VPC"
}

variable "additional_settings" {
  type = list(object({
    namespace = string
    name      = string
    value     = string
  }))

  description = "Additional Elastic Beanstalk setttings. For full list of options, see https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/command-options-general.html"
  default     = []
}

variable "env_vars" {
  type        = map(string)
  default     = {}
  description = "Map of custom ENV variables to be provided to the application running on Elastic Beanstalk, e.g. env_vars = { DB_USER = 'admin' DB_PASS = 'xxxxxx' }"
}

variable "scheduled_actions" {
  type = list(object({
    name            = string
    minsize         = string
    maxsize         = string
    desiredcapacity = string
    starttime       = string
    endtime         = string
    recurrence      = string
    suspend         = bool
  }))
  default     = []
  description = "Define a list of scheduled actions"
}

variable "s3_bucket_versioning_enabled" {
  type        = bool
  description = "When set to 'true' the s3 origin bucket will have versioning enabled"
}

variable "enable_loadbalancer_logs" {
  type        = bool
  description = "Whether to enable Load Balancer Logging to the S3 bucket."
}

variable "ecr_repository_name" {
  type        = string
  description = "Name of the ECR repository to create"
  default     = "my-webapp-repository" # Change this to your desired ECR repository name
}

variable "acm_certificate_domain" {
  type        = string
  description = "Domain name for which the ACM certificate is issued"
}

variable "db_instance_identifier" {
  type        = string
  description = "Identifier for the RDS instance"
}

variable "db_name" {
  type        = string
  description = "Name of the initial database"
}

variable "db_username" {
  type        = string
  description = "Username for the RDS database"
}

variable "db_password" {
  type        = string
  description = "Password for the RDS database"
  sensitive   = true
}

variable "db_instance_class" {
  type        = string
  description = "Instance class for the RDS database"
}

variable "db_allocated_storage" {
  type        = number
  description = "Allocated storage (GB) for the RDS database"
}

variable "db_engine_version" {
  type        = string
  description = "Version of PostgreSQL engine"
}

variable "db_multi_az" {
  type        = bool
  description = "Enable Multi-AZ deployment for high availability"
}

variable "db_deletion_protection" {
  type        = bool
  description = "Enable deletion protection for the RDS instance"
}

variable "db_storage_encrypted" {
  type        = bool
  description = "Enable storage encryption at rest for the RDS instance"
  default     = true # Default value - you'll override in test.tfvars
}

variable "major_engine_version" {
  type        = string
  description = "The major engine version of the database (e.g., '14' for PostgreSQL 14 or '8.0' for MySQL 8.0)"
}