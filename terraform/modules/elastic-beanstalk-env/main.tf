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

  # Docker Configuration (Basic example - you might need Dockerrun.aws.json for more complex setups)
  setting {
    namespace = "aws:elasticbeanstalk:container:docker:dockerrunaws"
    name      = "DockerrunFilename" # Dummy name, we are using direct content
    value = jsonencode({
      "AWSEBDockerrunVersion" : "1",
      "Image" : var.docker_image, # e.g., from ecr module output + tag
      "Ports" : [
        {
          "ContainerPort" : var.container_port,
          "HostPort"      : var.host_port
        }
      ],
      "Logging": "awslogs-region:us-east-1,awslogs-group:elasticbeanstalk-app" #Example, adjust region/group
    })
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

  # Option to enable Rolling Updates for deployments
  setting {
    namespace = "aws:elasticbeanstalk:rollingupdates"
    name      = "RollingUpdateEnabled"
    value     = var.enable_rolling_updates ? "true" : "false" # Conditional based on variable
  }

  # Option to enable Load Balancer access logs (S3 bucket needs to be configured separately)
  setting {
    namespace = "aws:elasticbeanstalk:loadbalancer"
    name      = "AccessLogsEnabled"
    value     = var.enable_lb_access_logs ? "true" : "false" # Conditional based on variable
  }


  # Tags (Optional, but good practice)
  tags = var.tags
}