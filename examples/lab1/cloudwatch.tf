resource "aws_cloudwatch_log_group" "eks_cluster_control_plane_components" {
  name = "/aws/eks/${var.cluster_name}/cluster"
  retention_in_days = 1
}