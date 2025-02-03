variable "application_name" {
  type        = string
  description = "Name of the Elastic Beanstalk Application"
  default     = "my-webapp" # Change this to your application name
}

variable "environment_name" {
  type        = string
  description = "Name of the Elastic Beanstalk Environment"
  default     = "dev-environment" # Change this to your desired environment name
}

variable "ecr_repository_name" {
  type        = string
  description = "Name of the ECR repository to create"
  default     = "my-webapp-repository" # Change this to your desired ECR repository name
}

variable "docker_image" {
  type        = string
  description = "Docker image to deploy (e.g., Docker Hub or ECR image URL)"
}

variable "acm_certificate_domain" {
  type        = string
  description = "Domain name for which the ACM certificate is issued"
}

variable "enable_https" {
  type        = bool
  description = "Enable HTTPS for the Elastic Beanstalk environment"
  default     = false # HTTPS is disabled by default
}