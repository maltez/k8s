resource "aws_eks_cluster" "cluster" {
  name = var.cluster_name
  role_arn = aws_iam_role.eks_cluster.arn

  vpc_config {
    subnet_ids = concat(module.vpc.public_subnets, module.vpc.private_subnets)
    endpoint_public_access = true
    endpoint_private_access = true
  }

  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  depends_on = [
    aws_iam_role_policy_attachment.policy-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.policy-AmazonEKSVPCResourceController,
    aws_cloudwatch_log_group.eks_cluster_control_plane_components
  ]
}

resource "aws_eks_node_group" "node_group" {
  count = length(module.vpc.private_subnets)

  cluster_name = aws_eks_cluster.cluster.name
  node_group_name = "fnode_group-${substr(module.vpc.private_subnets[count.index],7, length(module.vpc.private_subnets[count.index]))}"
  node_role_arn = aws_iam_role.node_group.arn
  subnet_ids = [module.vpc.private_subnets[count.index]]

  scaling_config {
    desired_size = 1
    max_size = 3
    min_size = 1
  }
}

data "tls_certificate" "cluster" {
  url = aws_eks_cluster.cluster.identity.0.oidc.0.issuer
}

resource "aws_iam_openid_connect_provider" "cluster" {
  client_id_list = ["sts.amazonaws.com"]
  thumbprint_list = concat([data.tls_certificate.cluster.certificates.0.sha1_fingerprint], [])
  url = aws_eks_cluster.cluster.identity.0.oidc.0.issuer
}