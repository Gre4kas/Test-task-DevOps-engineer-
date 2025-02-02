resource "aws_elastic_beanstalk_environment" "environment" {
  name                = var.environment_name
  application         = var.application_name
  solution_stack_name = var.solution_stack_name

  # -------------------------------------------------------------------------------------------------------------------
  # Instance Configuration (aws:autoscaling:launchconfiguration)
  # -------------------------------------------------------------------------------------------------------------------
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = var.instance_type
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = var.instance_profile_arn
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "EC2KeyName" # Recommended: For SSH Access (Optional, configurable via variable)
    value     = var.ec2_key_name != "" ? var.ec2_key_name : "" # Conditional setting
  }

  # -------------------------------------------------------------------------------------------------------------------
  # Auto Scaling Group Configuration (aws:autoscaling:asg)
  # -------------------------------------------------------------------------------------------------------------------
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

  # -------------------------------------------------------------------------------------------------------------------
  # Rolling Updates Configuration (aws:autoscaling:updatepolicy:rollingupdate)
  # -------------------------------------------------------------------------------------------------------------------
  setting {
    namespace = "aws:autoscaling:updatepolicy:rollingupdate"
    name      = "RollingUpdateEnabled" # Recommended: Enable Rolling Updates for smoother deployments
    value     = var.enable_rolling_updates ? "true" : "false"
  }

  setting {
    namespace = "aws:autoscaling:updatepolicy:rollingupdate"
    name      = "RollingUpdateType" # Recommended: Instance health based rolling updates
    value     = "Health" # Or "Time", "Immutable" - "Health" is generally a good default
  }

  # -------------------------------------------------------------------------------------------------------------------
  # Application Health Check (aws:elasticbeanstalk:application)
  # -------------------------------------------------------------------------------------------------------------------
  setting {
    namespace = "aws:elasticbeanstalk:application"
    name      = "Application Healthcheck URL" # Recommended: More general application health check
    # Use var.application_healthcheck_url if provided, otherwise default to "/"
    value     = var.application_healthcheck_url != null ? var.application_healthcheck_url : "/"
  }

  # -------------------------------------------------------------------------------------------------------------------
  # Command Deployment Policy (aws:elasticbeanstalk:command)
  # -------------------------------------------------------------------------------------------------------------------
  setting {
    namespace = "aws:elasticbeanstalk:command"
    name      = "DeploymentPolicy" # Recommended: Rolling deployments for minimal downtime
    value     = "Rolling" # Or "AllAtOnce", "BlueGreen", "Immutable"
  }

  setting {
    namespace = "aws:elasticbeanstalk:command"
    name      = "BatchSize" # Recommended: Batch size for rolling deployments
    value     = "30"      # Percentage or number, adjust as needed
  }

  setting {
    namespace = "aws:elasticbeanstalk:command"
    name      = "BatchSizeType" # Recommended: Use percentage for batch size
    value     = "Percentage" # Or "Fixed"
  }

  # -------------------------------------------------------------------------------------------------------------------
  # Environment Service Role (aws:elasticbeanstalk:environment)
  # -------------------------------------------------------------------------------------------------------------------
  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "ServiceRole"
    value     = var.service_role_arn
  }
  
  # -------------------------------------------------------------------------------------------------------------------
  # Enhanced Health Reporting (aws:elasticbeanstalk:healthreporting:system)
  # -------------------------------------------------------------------------------------------------------------------
  setting {
    namespace = "aws:elasticbeanstalk:healthreporting:system"
    name      = "SystemType"
    value     = "enhanced"
  }

  setting {
    namespace = "aws:elasticbeanstalk:healthreporting:system"
    name      = "HealthCheckSuccessThreshold" # Recommended: Adjust health check sensitivity (Optional)
    value     = "Ok" # Or "Warning", "Degraded", "Severe" - "Ok" is default and reasonable
  }

  # -------------------------------------------------------------------------------------------------------------------
  # Load Balancer Cross-Zone Load Balancing (aws:elb:loadbalancer)
  # -------------------------------------------------------------------------------------------------------------------
  setting {
    namespace = "aws:elb:loadbalancer"
    name      = "CrossZone" # Recommended: Enable for High Availability
    value     = "true"
  }

  # -------------------------------------------------------------------------------------------------------------------
  # Load Balancer Connection Draining (aws:elb:policies)
  # -------------------------------------------------------------------------------------------------------------------
  setting {
    namespace = "aws:elb:policies"
    name      = "ConnectionDrainingEnabled" # Recommended: Enable for graceful deployments
    value     = "true"
  }

  setting {
    namespace = "aws:elb:policies"
    name      = "ConnectionDrainingTimeout" # Recommended: Timeout for connection draining
    value     = "30" # Seconds, adjust as needed
  }

  # -------------------------------------------------------------------------------------------------------------------
  # Docker Configuration using Environment Properties (aws:elasticbeanstalk:application:environment)
  # -------------------------------------------------------------------------------------------------------------------
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "EB_DOCKER_IMAGE"
    value     = var.docker_image
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "PORT"
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

  # Managed Database (PostgreSQL in-environment) - Kept as before
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
    value     = var.db_password
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

  # Explicitly Disable Managed Actions - Keeping this disabled for initial setup
  setting {
    namespace = "aws:elasticbeanstalk:managedactions"
    name      = "ManagedActionsEnabled"
    value     = "false" # Keep disabled for now
  }

  # VPC Configuration -  Use outputs from the network module
  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = var.vpc_id # From network module output
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = join(",", var.public_subnet_ids) # From network module output, comma-separated string
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "AssociatePublicIpAddress" # Required for public subnets and internet access
    value     = "true" # Or "false" if you only want private instances and NAT gateway
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration" # Security Groups are set at the environment level in EB
    name      = "SecurityGroups"
    value     = var.elastic_beanstalk_sg_id # From network module output
  }

  # Tags (Optional, but good practice)
  tags = var.tags
}