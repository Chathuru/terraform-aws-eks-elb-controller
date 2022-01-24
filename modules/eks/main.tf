resource "aws_eks_cluster" "eks" {
  name     = local.eks_cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn
  version  = var.eks_version

  vpc_config {
    subnet_ids              = concat(var.public_subnet_ids, var.private_subnet_ids)
    public_access_cidrs     = var.eks_public_access_cidrs
    security_group_ids      = var.security_group_ids
    endpoint_public_access  = var.eks_endpoint_public_access
    endpoint_private_access = var.eks_endpoint_private_access
  }

  tags = merge({
    Name = join("-", [var.environment, var.project, var.cluster_name])
  }, var.tags)

  depends_on = [aws_iam_role.eks_cluster_role]
}

resource "aws_launch_template" "launch_template" {
  for_each = var.node_groups_configs

  name                   = join("-", [var.environment, var.project, each.key, "lt"])
  image_id               = lookup(each.value, "image_id", data.aws_ami.eks_worker.id)
  instance_type          = lookup(each.value, "instance_type")
  key_name               = lookup(each.value, "key_name", null)
  vpc_security_group_ids = var.node_group_security_ids != [] ? lookup(each.value, "node_group_security_ids", var.security_group_ids) : var.node_group_security_ids
  user_data              = base64encode(local.user_data)
  update_default_version = true

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = lookup(each.value, "volume_size", 20)
      volume_type = lookup(each.value, "volume_type", "gp2")
    }
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = join("-", [var.environment, var.project, each.key])
    }
  }

  tag_specifications {
    resource_type = "volume"

    tags = {
      Name = join("-", [var.environment, var.project, each.key])
    }
  }

  depends_on = [aws_eks_cluster.eks]
}

resource "aws_eks_node_group" "node_group" {
  for_each = var.node_groups_configs

  cluster_name    = local.eks_cluster_name
  node_group_name = join("-", [var.environment, var.project, each.key, "ng"])
  node_role_arn   = aws_iam_role.eks_cluster_node_role.arn
  subnet_ids      = var.eks_endpoint_private_access ? var.private_subnet_ids : var.public_subnet_ids

  launch_template {
    id      = lookup(aws_launch_template.launch_template[each.key], "id")
    version = lookup(aws_launch_template.launch_template[each.key], "latest_version")
  }

  scaling_config {
    desired_size = lookup(each.value, "desired_size", 1)
    max_size     = lookup(each.value, "max_size", 2)
    min_size     = lookup(each.value, "min_size", 1)
  }

  update_config {
    max_unavailable = lookup(each.value, "max_unavailable", 1)
  }

  depends_on = [aws_eks_cluster.eks, aws_iam_role.eks_cluster_node_role, aws_launch_template.launch_template]
}

resource "aws_eks_node_group" "node_group_spot_instances" {
  for_each = var.managed_node_group_configs

  cluster_name    = local.eks_cluster_name
  node_group_name = join("-", [var.environment, var.project, each.key, "ng"])
  node_role_arn   = aws_iam_role.eks_cluster_node_role.arn
  subnet_ids      = var.eks_endpoint_private_access ? var.private_subnet_ids : var.public_subnet_ids
  ami_type        = lookup(each.value, "ami_type", "AL2_x86_64")
  capacity_type   = lookup(each.value, "capacity_type", "ON_DEMAND")
  instance_types  = lookup(each.value, "instance_types", ["t3.medium"])
  disk_size       = lookup(each.value, "disk_size", 20)

  scaling_config {
    desired_size = lookup(each.value, "desired_size", 1)
    max_size     = lookup(each.value, "max_size", 2)
    min_size     = lookup(each.value, "min_size", 1)
  }

  update_config {
    max_unavailable = lookup(each.value, "max_unavailable", 1)
  }

  depends_on = [aws_eks_cluster.eks, aws_iam_role.eks_cluster_node_role]
}
