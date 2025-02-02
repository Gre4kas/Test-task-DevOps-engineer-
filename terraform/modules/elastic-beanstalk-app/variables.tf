variable "application_name" {
  type        = string
  description = "The name of the Elastic Beanstalk application"
}

variable "application_description" {
  type        = string
  description = "A description for the Elastic Beanstalk application"
  default     = "Managed by Terraform"
  nullable    = true # Allow null/empty description
}