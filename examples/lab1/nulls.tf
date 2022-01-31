data "template_file" "aws_auth_configmap" {
  template = file("${path.module}/aws-configmap.yaml.tpl")

  vars = {
    arn_instance_role = aws_iam_role.node_group.arn
  }
}

resource "null_resource" "generate_kubeconfig" {
  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --name ${var.cluster_name} --region ${var.region}"
  }

  depends_on = [aws_eks_cluster.cluster]
}

resource "null_resource" "apply_aws_configmap" {

  provisioner "local-exec" {
    command = "echo '${data.template_file.aws_auth_configmap.rendered}' > aws-auth-cm.yaml && kubectl apply -f aws-auth-cm.yaml && rm aws-auth-cm.yaml"
  }

  depends_on = [null_resource.generate_kubeconfig]
}