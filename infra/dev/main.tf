provider "aws" {
  region  = var.region
  profile = var.aws_profile
}

module "vpc" {
  source             = "../../modules/vpc"
  environment        = var.environment
  project            = var.project
  cidr_block         = var.cidr_block
  public_subnets     = var.public_subnets
  common_tags        = local.common_tags
  public_subnet_tags = local.public_subnet_tags
}

module "eks_security_group" {
  source              = "../../modules/security_group"
  aws_vpc_id          = module.vpc.vpc_id
  description         = "dev eks cluster node group sg"
  environment         = var.environment
  project             = var.project
  security_group_name = "eks-cluster-node-group"
  extra_tags          = local.common_tags

  security_group_rules = [
    {
      type        = "ingress"
      to_port     = 0
      protocol    = -1
      from_port   = 65536
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      type      = "ingress"
      to_port   = 0
      protocol  = -1
      from_port = 65536
      self      = true
    }
  ]
}

module "eks" {
  source             = "../../modules/eks"
  cluster_name       = var.eks_cluster_name
  environment        = var.environment
  project            = var.project
  public_subnet_ids  = module.vpc.public_subnets
  security_group_ids = [module.eks_security_group.security_group_id]
  managed_node_group_configs = {
    "spot" = {
      capacity_type  = "SPOT"
      instance_types = ["t3.small", "t3.medium", "t3.large"]
      disk_size      = 30
    }
  }
}
