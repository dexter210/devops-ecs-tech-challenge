variable "aws_region" {
  description = "AWS region used for the DevOps challenge"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Name prefix for project resources"
  type        = string
  default     = "devops-tech-challenge"
}

variable "vpc_cidr" {
  description = "CIDR range for the project VPC"
  type        = string
  default     = "10.0.0.0/16"
}