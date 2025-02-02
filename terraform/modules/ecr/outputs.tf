output "repository_url" {
  description = "The repository URI (URL) for pushing and pulling Docker images"
  value       = aws_ecr_repository.repository.repository_url
}

output "repository_arn" {
  description = "The ARN of the ECR repository"
  value       = aws_ecr_repository.repository.arn
}

output "repository_name" {
  description = "The name of the ECR repository"
  value       = aws_ecr_repository.repository.name
}