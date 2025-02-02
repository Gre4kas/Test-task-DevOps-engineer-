output "service_role_arn" {
  description = "ARN of the Elastic Beanstalk Service Role"
  value       = aws_iam_role.aws-elasticbeanstalk-service-role.arn
}

output "instance_profile_arn" {
  description = "ARN of the Elastic Beanstalk EC2 Instance Profile"
  value       = aws_iam_instance_profile.aws-elasticbeanstalk-ec2-instance-profile.arn
}

output "instance_role_arn" {
  description = "ARN of the Elastic Beanstalk EC2 Instance Role"
  value       = aws_iam_role.aws-elasticbeanstalk-ec2-role.arn
}
