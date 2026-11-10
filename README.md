# DevOps Tech Challenge — React + Express on Amazon ECS Fargate

## Project Overview

This project deploys a containerized React frontend and Express/Node.js backend to AWS using Amazon ECS with Fargate. The infrastructure is provisioned with Terraform, container images are stored in Amazon ECR, traffic is routed through an Application Load Balancer, and deployments are automated from the `gitops` branch with GitHub Actions using AWS OIDC authentication.

The goal of this repository is to demonstrate a complete cloud deployment workflow that is reproducible, secure, observable, and automated.

## Architecture

The final application flow is:

```text
Developer
   ↓
GitHub — gitops branch
   ↓
GitHub Actions
   ↓
AWS OIDC / IAM Role
   ↓
Build Docker Images
   ↓
Amazon ECR
   ↓
Amazon ECS / Fargate
   ↓
Application Load Balancer
   ├── /       → Frontend ECS Service
   └── /api/*  → Backend ECS Service
   ↓
CloudWatch + ECS Auto Scaling
```

> Architecture diagram will be added here after final review.


## Submission Requirements

This repository is structured to satisfy the challenge submission requirements:

- All source code, infrastructure code, workflows, and project assets are version controlled in GitHub.
- The repository includes this README with installation, local execution, Docker, Terraform, and deployment instructions.
- The frontend and backend are fully Dockerized.
- The application has been validated locally before deployment.
- The deployed application runs on AWS ECS Fargate.
- GitHub Actions automates container build, image push, and ECS deployment from the `gitops` branch.
- The final submission must include a hyperlink to this GitHub repository.
- Because the repository is private, access must be shared with **michaeltayo96@outlook.com** before submission.
- The project should remain runnable and reproducible from the instructions in this README.

> Submission note: before submitting, verify that the repository collaborator/invite has been added for **michaeltayo96@outlook.com** and that the public application endpoint is still reachable.

## Technology Stack

| Area | Technology |
| --- | --- |
| Frontend | React |
| Backend | Node.js / Express |
| Containerization | Docker |
| Frontend Web Server | Nginx |
| Infrastructure as Code | Terraform |
| Container Registry | Amazon ECR |
| Container Orchestration | Amazon ECS |
| Compute | AWS Fargate |
| Load Balancing | Application Load Balancer |
| Monitoring | Amazon CloudWatch |
| Auto Scaling | ECS Service Auto Scaling |
| CI/CD | GitHub Actions |
| AWS Authentication | GitHub OIDC + IAM |

## Repository Structure

```text
.
├── .github/
│   └── workflows/
├── backend/
├── frontend/
├── terraform/
├── screenshots/
└── README.md
```

## 1. Local Application Validation

This section documents the initial validation of the supplied React frontend and Express backend before containerization.

### Evidence

_Screenshots will be added after review._

## 2. Docker Containerization

The backend was packaged into a Node.js container, while the React frontend was compiled with a multi-stage Docker build and served through Nginx.

The application was validated locally in containers before moving to AWS.

### Evidence

_Screenshots will be added after review._

## 3. Terraform Infrastructure

Terraform is used to provision the AWS application infrastructure, including networking, ECR, load balancing, ECS, IAM, CloudWatch, and service auto scaling.

### AWS Networking

The application uses a dedicated VPC with public subnets across multiple Availability Zones, an Internet Gateway, and routing required for the internet-facing Application Load Balancer and Fargate tasks.

### Evidence

_Screenshots will be added after review._

## 4. Amazon ECR

Separate ECR repositories store the frontend and backend Docker images. Image scanning is enabled to help identify known package vulnerabilities.

### Evidence

_Screenshots will be added after review._

## 5. Application Load Balancer

The Application Load Balancer acts as the public entry point for the application.

Routing behavior:

```text
/       → Frontend Target Group → Frontend ECS Service
/api/*  → Backend Target Group  → Backend ECS Service
```

### Evidence

_Screenshots will be added after review._

## 6. Amazon ECS and Fargate

The application runs as two ECS services:

### Frontend Service

- Fargate
- 0.5 vCPU
- 1 GB memory
- Container port 80
- Minimum tasks: 1
- Desired tasks: 1
- Maximum tasks: 4

### Backend Service

- Fargate
- 0.5 vCPU
- 1 GB memory
- Container port 8080
- Minimum tasks: 1
- Desired tasks: 1
- Maximum tasks: 4

### Evidence

_Screenshots will be added after review._

## 7. Troubleshooting and CloudWatch

CloudWatch is used for container logging and ECS service metrics.

During the first ECS frontend deployment, the Nginx configuration referenced a Docker-local hostname that was valid on the local Docker network but unavailable in ECS. The configuration was corrected so that the Application Load Balancer handles `/api/*` routing in AWS.

### Evidence

_Screenshots will be added after review._

## 8. ECS Auto Scaling Validation

Both ECS services use target tracking based on average CPU utilization.

Configuration:

- Minimum tasks: 1
- Desired tasks: 1
- Maximum tasks: 4
- Target CPU utilization: 50%

During load testing, the backend service successfully scaled horizontally from one Fargate task to four tasks and later returned to one task after demand subsided.

### Evidence

_Screenshots will be added after review._

## 9. GitOps CI/CD with GitHub Actions

The `gitops` branch contains the automated deployment workflow.

The workflow performs the following actions:

1. Checks out the repository.
2. Authenticates to AWS using GitHub OIDC.
3. Logs in to Amazon ECR.
4. Builds frontend and backend Docker images.
5. Tags the images with the Git commit SHA.
6. Pushes both images to ECR.
7. Registers new ECS task definition revisions.
8. Updates the frontend and backend ECS services.
9. Waits for both services to reach a stable state.

No long-lived AWS access keys are stored in GitHub.

### Evidence

_Screenshots will be added after review._

## 10. Deployment Validation

The final deployment is validated through the public Application Load Balancer endpoint.

The frontend is served through the ALB, while requests to `/api/*` are routed to the backend ECS service.

### Evidence

_Screenshots will be added after review._

## Deployment Workflow

```text
Code Change
   ↓
Push to gitops branch
   ↓
GitHub Actions
   ↓
OIDC Authentication
   ↓
Docker Build
   ↓
Amazon ECR
   ↓
New ECS Task Definition Revisions
   ↓
ECS Service Rolling Deployment
   ↓
Application Load Balancer
   ↓
Live Application
```

## Security Decisions

- GitHub Actions authenticates to AWS with OIDC rather than long-lived access keys.
- ECS tasks use a dedicated task execution role.
- The backend is not directly exposed to the public internet through its security group.
- Application traffic enters through the ALB.
- Terraform state and local provider cache files are excluded from Git.
- ECR image scanning is enabled.
- IAM permissions for GitHub Actions are limited to the deployment actions required by the project.

## Cost Management

This project uses billable AWS resources including Fargate tasks and an Application Load Balancer. Resources should be monitored and removed when they are no longer needed.

## Screenshots

Project evidence is stored in:

```text
screenshots/
```

The screenshots are intentionally numbered to preserve the order in which the project was built and validated.

## Status

**GitOps deployment: Completed**

The remaining documentation work is to select the strongest screenshots, add the final architecture diagram, and connect the evidence to the relevant sections above.
