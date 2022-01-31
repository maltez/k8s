apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
data:
  mapRoles: |
    - rolearn: ${arn_instance_role}
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:nodes
        - system:bootstrappers
        - system:masters
  mapUsers: |
    - userarn: arn:aws:iam::753788210905:user/k8s_course_for_delete
      username: student
      groups:
        - system:masters
    - userarn: arn:aws:iam::570902803005:user/nick.lototskiy@namecheap.com
          username: nick
          groups:
            - system:masters