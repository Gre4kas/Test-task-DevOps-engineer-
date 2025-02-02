variable "service_role_name" {
  type        = string
  description = "Name for the Elastic Beanstalk Service Role"
  default     = "aws-elasticbeanstalk-service-role"
}

variable "instance_role_name" {
  type        = string
  description = "Name for the Elastic Beanstalk EC2 Instance Role"
  default     = "aws-elasticbeanstalk-ec2-role"
}

variable "instance_profile_name" {
  type        = string
  description = "Name for the Elastic Beanstalk EC2 Instance Profile"
  default     = "aws-elasticbeanstalk-ec2-instance-profile"
}