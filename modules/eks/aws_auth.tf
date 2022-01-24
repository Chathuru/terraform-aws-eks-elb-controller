#resource "kubernetes_config_map" "aws_auth" {
#  count = length(var.map_users) == 0 ? 0 : 1
#
#  metadata {
#    name      = "aws-auth"
#    namespace = "kube-system"
#    labels = {
#      "app.kubernetes.io/managed-by" = "Terraform"
#    }
#  }
#
#  data = {
#    mapRoles = yamlencode(distinct(local.map_role))
#    mapUsers = yamlencode(var.map_users)
#  }
#}
#  map_role =[{
#    groups = tolist(concat(
#    [
#      "system:bootstrappers",
#      "system:nodes",
#    ])),
#    rolearn = aws_iam_role.eks_cluster_node_role.arn,
#    username = "system:node:{{EC2PrivateDNSName}}"
#  }]