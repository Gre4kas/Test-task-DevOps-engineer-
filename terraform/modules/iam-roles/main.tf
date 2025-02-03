resource "aws_iam_role" "aws-elasticbeanstalk-service-role" {
  name = var.service_role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "elasticbeanstalk.amazonaws.com"
        }
        Effect = "Allow"
        Sid = ""
      },
    ]
  })
  path = "/"
}

# Replace the managed policy attachment with a custom policy
resource "aws_iam_policy" "elasticbeanstalk-service-policy" {
  name        = "${var.service_role_name}-policy-full-access-test" # Updated name to indicate full access and test
  description = "PERMISSIVE POLICY FOR TESTING ONLY - Grants FULL AWS ACCESS to Elastic Beanstalk Service Role - DO NOT USE IN PRODUCTION" # Clear warning
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["*"]       # Grant ALL actions
        Effect   = "Allow"
        Resource = ["*"]       # Grant access to ALL resources
      },
    ]
  })
}

resource "aws_iam_policy_attachment" "aws-elasticbeanstalk-service-role-policy-attachment" {
  name       = "ElasticBeanstalkService-custom-policy-attachment" # Updated name
  roles      = [aws_iam_role.aws-elasticbeanstalk-service-role.name]
  policy_arn = aws_iam_policy.elasticbeanstalk-service-policy.arn # Attach the custom policy
}

resource "aws_iam_role" "aws-elasticbeanstalk-ec2-role" {
  name = var.instance_role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Effect = "Allow"
        Sid = ""
      },
    ]
  })
  path = "/"
}

resource "aws_iam_instance_profile" "aws-elasticbeanstalk-ec2-instance-profile" {
  name = var.instance_profile_name
  role = aws_iam_role.aws-elasticbeanstalk-ec2-role.name
  path = "/"
}


resource "aws_iam_policy_attachment" "aws-elasticbeanstalk-ec2-role-policy" {
  name       = "AWSElasticBeanstalkWebTier-policy-attachment" # Or AWSElasticBeanstalkWorkerTier if worker tier
  roles      = [aws_iam_role.aws-elasticbeanstalk-ec2-role.name]
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier" # Or AWSElasticBeanstalkWorkerTier
}

resource "aws_iam_policy" "ecr-pull-policy" {
  name        = "${var.instance_role_name}-ecr-pull-policy"
  description = "Policy to allow EC2 instances to pull images from ECR"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage"
        ],
        Effect   = "Allow",
        Resource = "*" # You can restrict this to specific ECR repositories for tighter security in production
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "ecr-pull-policy-attachment" {
  name       = "ecr-pull-policy-attachment"
  roles      = [aws_iam_role.aws-elasticbeanstalk-ec2-role.name]
  policy_arn = aws_iam_policy.ecr-pull-policy.arn
}


resource "aws_iam_policy" "cloudwatch-logs-policy" {
  name        = "${var.instance_role_name}-cloudwatch-logs-policy"
  description = "Policy to allow EC2 instances to write logs to CloudWatch Logs"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams"
        ],
        Effect   = "Allow",
        Resource = ["arn:aws:logs:*:*:*"] # You can restrict this further if needed
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "cloudwatch-logs-policy-attachment" {
  name       = "cloudwatch-logs-policy-attachment"
  roles      = [aws_iam_role.aws-elasticbeanstalk-ec2-role.name]
  policy_arn = aws_iam_policy.cloudwatch-logs-policy.arn
}