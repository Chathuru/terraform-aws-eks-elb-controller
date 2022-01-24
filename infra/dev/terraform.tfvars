region           = "us-east-1"
aws_profile      = "default"
environment      = "dev"
project          = "app"
eks_cluster_name = "eks"
cidr_block       = "10.22.0.0/16"
public_subnets   = { "us-east-1a" : "10.22.0.0/18", "us-east-1b" : "10.22.64.0/18" }
