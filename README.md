# Introduction

## 1.1. Project Overview

This project demonstrates how to deploy a Dockerized web application to AWS Elastic Beanstalk using AWS CDK for infrastructure provisioning and a CI/CD pipeline for automated deployments.  It showcases best practices for containerizing applications, managing infrastructure as code, and automating the deployment process.  This project includes Terraform modules that can be used alongside CDK for networking, RDS, and ECR.

## 1.2. Purpose and Goals

The primary goals of this project are to:

*   **Automate Infrastructure Provisioning:** Utilize AWS CDK to define and deploy the necessary AWS resources (ECR repository, Elastic Beanstalk environment, IAM roles, Security Groups).
*   **Containerize the Application:** Package the web application as a Docker container for portability and consistency.
*   **Automate Deployments:** Implement a CI/CD pipeline using GitHub Actions to automatically build, test, and deploy the application whenever changes are pushed to the repository.
*   **Demonstrate Best Practices:** Adhere to AWS and Docker best practices for security, scalability, and maintainability.
*   **Infrastructure Modularity**: Using Terraform modules for ECR, RDS, and Networking.

## 1.3. Technologies Used

*   **Docker:**  A platform for containerizing applications.
*   **AWS Elastic Beanstalk:**  A service for deploying and managing web applications and services.
*   **AWS ECR (Elastic Container Registry):** A fully managed container registry for storing and managing Docker images.
*   **GitHub Actions:**  A CI/CD platform for automating software workflows.
*   **Python:** The programming language used for the web application.
*   **Terraform**: Infrastructure as Code tool, used to create reusable modules for networking, RDS, and ECR.

## Architecture Overview
![Description of the image](/images/Elastic%20Beanstalk%20infra.png)
This diagram illustrates the architecture of the deployed application within the AWS environment. The infrastructure is deployed within a specific AWS Region and encompasses the following key components:

1.  **Region:** The entire infrastructure resides within a designated AWS Region, providing geographical isolation and redundancy.

2.  **VPC (Virtual Private Cloud):** The core networking component, providing a logically isolated section of the AWS cloud where all resources are deployed. It spans at least one Availability Zone within the Region.

    *   **Availability Zone 1:**  The VPC is depicted as being in Availability Zone 1, but in reality can span more than one Availability Zone for increased resilience.

3.  **Subnets:** The VPC is divided into several subnets:

    *   **Public Subnet:**  Contains a NAT Gateway.  Resources in private subnets use the NAT Gateway to access the internet (for updates, etc.) without being directly exposed.
    *   **Private Subnet:** Hosts the Elastic Beanstalk environment.  Instances within Elastic Beanstalk run the application and are not directly accessible from the internet.
    *   **Private Subnet DB:** Dedicated subnet for the RDS (Relational Database Service) instance. This isolates the database for enhanced security.

4.  **Internet Gateway:** Allows communication between the VPC and the internet.  Traffic from the internet enters the VPC through the Internet Gateway.

5.  **Route 53:** A highly available and scalable DNS web service. It routes traffic to the Application Load Balancer (ALB) based on domain name resolution.

6.  **ALB (Application Load Balancer):** Distributes incoming application traffic across multiple targets (EC2 instances within the Elastic Beanstalk environment) in one or more Availability Zones. This improves the availability and scalability of the application.

7.  **Elastic Beanstalk:**  A PaaS (Platform as a Service) that simplifies the deployment and management of web applications. It automatically handles capacity provisioning, load balancing, auto-scaling, and application health monitoring.  In this architecture, it manages the EC2 instances running the Dockerized application.

8.  **RDS (Relational Database Service):** A managed database service providing a relational database backend (e.g., MySQL, PostgreSQL).  The application interacts with the database to store and retrieve data.

9.  **NAT Gateway:** A network address translation (NAT) service. Resources in the private subnets can use it to connect to the internet for outbound traffic, while preventing inbound connections from the internet.

10. **IAM (Identity and Access Management):**  Controls access to AWS services and resources. IAM roles are used to grant permissions to various components (e.g., Elastic Beanstalk instances, RDS).  Not explicitly shown, but heavily used.

11. **Certificate Manager:** Used to provision, manage, and deploy SSL/TLS certificates with AWS services. Usually associated with the ALB for HTTPS traffic.

12. **Users:** Represents the end-users accessing the application through the internet.

**Traffic Flow:**

1.  Users access the application via the internet.
2.  Route 53 resolves the domain name to the ALB's IP address.
3.  The ALB distributes incoming traffic to the EC2 instances within the Elastic Beanstalk environment.
4.  The application running on the EC2 instances interacts with the RDS database to store and retrieve data.
5.  Resources in the private subnets use the NAT Gateway for outbound internet access.

**Security:**

*   The RDS instance is located in a private subnet, isolating it from direct internet access.
*   Security groups are configured to control inbound and outbound traffic to the EC2 instances and the RDS instance.
*   IAM roles are used to grant specific permissions to the resources, following the principle of least privilege.

## CI/CD Pipeline Overview (GitHub Actions)
![Description of the image2](/images/Github%20Action%20ci-cd.png)
This diagram illustrates the automated CI/CD pipeline used to build, test, and deploy the Dockerized application to AWS Elastic Beanstalk.  The pipeline is triggered by code changes pushed to the GitHub repository and is implemented using GitHub Actions.

**Components:**

1.  **Dev (Developers):** Developers commit and push code changes to the GitHub repository.

2.  **Git Repository (GitHub):** The central code repository hosted on GitHub. This repository contains the application source code, Dockerfile, CDK infrastructure code, and the GitHub Actions workflow definition.

3.  **GitHub Actions Workflow (`.github/workflows/ci-cd-pipeline.yml`):** Defines the automated steps in the CI/CD pipeline.  It is triggered by specific events in the GitHub repository (e.g., a push to the `main` branch).

4. **CodePipeline (Representing GitHub Actions Workflow Execution):** This represents the overall execution of the GitHub Actions workflow.

5.  **Pipeline Stages (Within the GitHub Actions Workflow):**

    *   **Source:** This stage retrieves the latest code from the GitHub repository. It's effectively a checkout operation.
    *   **CodeBuild:** This stage builds the Docker image from the `Dockerfile` and runs any unit tests defined in the project.
    *   **CodeDeploy:** This stage deploys the newly built Docker image to AWS Elastic Beanstalk.

6. **ECR (Elastic Container Registry):** The built Docker image is pushed to ECR, where it is stored and managed. ECR acts as the registry for the Docker images used by Elastic Beanstalk.

## Application Verification

The following screenshots demonstrate the successful deployment and operation of the web application within the Elastic Beanstalk environment.

**1. Welcome Page:**

![Welcome Page](/images/welcome_to_the_flask_app.jpg)

The screenshot shows the welcome page of the Flask application. It confirms that the application is running and accessible through the Elastic Beanstalk environment's URL: `https://devops-project-test-free-tier-eb-env.eba-kmmz2vfw.us-east-1.elasticbeanstalk.com/`.  The page also indicates the availability of a health check endpoint at `/health`.

**2. Health Check Endpoint:**

![Health Check](/images/status_heathy.jpg)

This screenshot displays the output of the `/health` endpoint.  The JSON response `{"status": "healthy"}` confirms that the application is in a healthy state and responding correctly to requests.