resource "aws_elastic_beanstalk_application" "application" {
  name        = var.application_name
  description = var.application_description
}