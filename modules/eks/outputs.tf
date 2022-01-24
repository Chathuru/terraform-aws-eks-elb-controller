output "eks_endpoint" {
  description = "The endpoint for your EKS Kubernetes API."
  value       = aws_eks_cluster.eks.endpoint
}

output "eks_certificate_authority" {
  description = ""
  value       = aws_eks_cluster.eks.certificate_authority[0].data
}

output "id" {
  description = "The id of the EKS cluster."
  value       = aws_eks_cluster.eks.id
}

output "oidc_issuer" {
  description = "The URL on the EKS cluster OIDC Issuer."
  value       = aws_eks_cluster.eks.identity[0].oidc[0].issuer
}

output "oidc_issuer_no_protocol" {
  description = "The URL on the EKS cluster OIDC Issuer. Without https://"
  value       = trimprefix(aws_eks_cluster.eks.identity[0].oidc[0].issuer, "https://")
}

output "thumbprint" {
  description = "Thumbprint of Root CA for EKS OIDC, Valid until 2037. (9e99a48a9960b14926bb7f3b02e22da2b0ab7280)"
  value       = data.tls_certificate.eks_oidc.certificates[0].sha1_fingerprint
}

output "alb_iam_role_arn" {
  description = "IAM role arn of the role to use in ALB ingress controller."
  value       = aws_iam_role.alb_role.arn
}

output "node_role_arn" {
  description = "EKS Cluster Node role ARN"
  value = aws_iam_role.eks_cluster_node_role.arn
}
