variable "vpc_name" {
  type        = string
  description = "Name to be used for the VPC"
  default     = "eb-app-vpc"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnets_cidr" {
  type        = list(string)
  description = "List of CIDR blocks for public subnets"
  default     = ["10.0.1.0/24", "10.0.2.0/24"] # Example for 3 AZs
}

variable "private_subnets_cidr" {
  type        = list(string)
  description = "List of CIDR blocks for private subnets"
  default     = ["10.0.11.0/24", "10.0.12.0/24"] # Example for 3 AZs
}

variable "vpc_tags" {
  type        = map(string)
  description = "Tags to apply to the VPC"
  default     = {}
}

variable "public_subnet_tags" {
  type        = map(string)
  description = "Tags to apply to public subnets"
  default     = {}
}

variable "private_subnet_tags" {
  type        = map(string)
  description = "Tags to apply to private subnets"
  default     = {}
}

variable "elastic_beanstalk_sg_name" {
  type        = string
  description = "Name for the Elastic Beanstalk Security Group"
  default     = "elastic-beanstalk-sg"
}

variable "elastic_beanstalk_sg_tags" {
  type        = map(string)
  description = "Tags to apply to the Elastic Beanstalk Security Group"
  default     = {}
}