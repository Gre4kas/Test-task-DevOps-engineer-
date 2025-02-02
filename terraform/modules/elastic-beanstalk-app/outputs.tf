output "application_name" {
  description = "The name of the Elastic Beanstalk application"
  value       = aws_elastic_beanstalk_application.application.name
}

output "application_arn" {
  description = "The ARN of the Elastic Beanstalk application"
  value       = aws_elastic_beanstalk_application.application.arn
}