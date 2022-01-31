variable "access_key" {
  type = string
}

variable "secret_key" {
  type = string
}

variable "region" {
  type = string
  description = "Specify AWS region"
  default = "us-west-2"
}

variable "cluster_name" {
  type = string
  description = "Specify EKS cluster name"
  default = "StudyCluster"
}

locals {
  shared = "shared"
}