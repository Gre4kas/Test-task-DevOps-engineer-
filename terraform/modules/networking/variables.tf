output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = module.vpc.public_subnets
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = module.vpc.private_subnets
}

output "elastic_beanstalk_sg_id" {
  description = "ID of the Security Group for Elastic Beanstalk instances"
  value       = aws_security_group.elastic_beanstalk_sg.id
}

output "default_security_group_id" {
  description = "Default security group ID of the VPC"
  value = module.vpc.default_security_group_id
}

output "natgw_ids" {
  description = "List of NAT Gateway IDs"
  value = module.vpc.natgw_ids
}