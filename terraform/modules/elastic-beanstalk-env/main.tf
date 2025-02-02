resource "aws_elastic_beanstalk_environment" "environment" {
  name                = var.environment_name
  application         = var.application_name # From elastic-beanstalk-app module output
  solution_stack_name = var.solution_stack_name # e.g., "64bit Amazon Linux 2 v5.6.7 running Docker"

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = var.instance_type
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MinSize"
    value     = var.min_instances
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MaxSize"
    value     = var.max_instances
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "ServiceRole"
    value     = var.service_role_arn # From iam-roles module output
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment:process:default" # For Web Tier
    name      = "HealthCheckPath"
    value     = var.health_check_path
  }

  # Docker Configuration using Environment Properties
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "EB_DOCKER_IMAGE" # Custom environment variable for Docker image
    value     = var.docker_image # e.g., from ecr module output + tag
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "PORT" # Standard environment variable for container port
    value     = var.container_port
  }

  # Environment Variables for the application
  dynamic "setting" {
    for_each = var.environment_variables
    content {
      namespace = "aws:elasticbeanstalk:application:environment"
      name      = setting.key
      value     = setting.value
    }
  }

  # Managed Database (PostgreSQL in-environment)
  setting {
    namespace = "aws:rds:dbinstance"
    name      = "DBEngine"
    value     = "postgres"
  }
  setting {
    namespace = "aws:rds:dbinstance"
    name      = "DBUser"
    value     = var.db_username
  }
  setting {
    namespace = "aws:rds:dbinstance"
    name      = "DBPassword"
    value     = var.db_password # Consider secrets management for production
  }
  setting {
    namespace = "aws:rds:dbinstance"
    name      = "DBInstanceClass"
    value     = var.db_instance_class
  }
  setting {
    namespace = "aws:rds:dbinstance"
    name      = "DBAllocatedStorage"
    value     = var.db_allocated_storage
  }
  setting {
    namespace = "aws:rds:dbinstance"
    name      = "DBEngineVersion"
    value     = var.db_engine_version
  }

  # Enhanced Health Reporting (Usually enabled by default, but explicit for clarity)
  setting {
    namespace = "aws:elasticbeanstalk:healthreporting:system"
    name      = "SystemType"
    value     = "enhanced"
  }

  # Instance Profile for EC2 instances
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = var.instance_profile_arn # From iam-roles module output
  }

  # AWS Elastic Beanstalk environment managed platform updates
  setting {
    namespace = "aws:elasticbeanstalk:managedactions"
    name      = "ManagedActionsEnabled"
    value     = "false"
  }

  # Tags (Optional, but good practice)
  tags = var.tags
}