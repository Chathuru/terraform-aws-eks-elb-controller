variable "region" {
  description = "AWS region which resource are creating"
  type        = string
}

variable "aws_profile" {
  description = "AWS profile name"
  type        = string
  default     = "default"
}

variable "environment" {
  description = "Environment Name"
  type        = string
}

variable "project" {
  description = "Name of the project"
  type        = string
}

variable "cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "public_subnets" {
  description = "A map of public subnets inside the VPC with respective availability zone"
  type        = map(string)
}

variable "eks_cluster_name" {
  description = "Name of the EKS cluster."
  type        = string
}
