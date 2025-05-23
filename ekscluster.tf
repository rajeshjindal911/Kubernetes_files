# EKS cluster 
resource "aws_eks_cluster" "eks-cluster" {
  name     = "${var.nodename}-${var.nodeid}-${var.env}-ekscl"
  role_arn = aws_iam_role.eks_cluster_role.arn
  vpc_config {
    subnet_ids = data.aws_subnets.nacl_subnets.ids
    endpoint_private_access = false
    endpoint_public_access  = true# change to false 

  }
#   encryption_config {
#     provider {
#       key_arn = aws_kms_key.eks_kms_key.arn
#     }
#     resources = [
#       "secrets"
#     ]
#   }
  enabled_cluster_log_types = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler"
  ]
  tags = {
    Name = "${var.nodename}-${var.nodeid}-${var.env}-ekscl"
    env  = var.env
    node = "${var.nodename}-${var.nodeid}"
  }
  depends_on = [
    aws_iam_role.eks_cluster_role
  ]
}

########## EKS add on configuration #########
resource "aws_eks_addon" "ekscl-coredns-addon" {
  cluster_name = aws_eks_cluster.eks-cluster.name
  addon_name   = "coredns"
  depends_on = [
    aws_iam_role.eks_node_role,
    aws_eks_node_group.ekscl-nodegroup
  ]
}

resource "aws_eks_addon" "ekscl-cni-addon" {
  cluster_name = aws_eks_cluster.eks-cluster.name
  addon_name   = "vpc-cni"
  depends_on = [
    aws_iam_role.eks_node_role,
    aws_eks_node_group.ekscl-nodegroup
  ]
}



########EKS node group configuration#############
resource "aws_eks_node_group" "ekscl-nodegroup" {
  cluster_name    = aws_eks_cluster.eks-cluster.name
  node_group_name = "${var.nodename}-${var.nodeid}-${var.env}-ekscl-ng-apse1"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids = data.aws_subnets.nacl_subnets.ids
  scaling_config {
    desired_size = 2
    max_size     = 2
    min_size     = 1
  }
  update_config {
    max_unavailable = 1
  }

#     launch_template {
#     id      = aws_launch_template.eks_launch_template.id
#     version = "$Latest"  # Use the latest version of the launch template
#   }
  ami_type = "AL2_x86_64"
  capacity_type = "ON_DEMAND"
  instance_types = [
      "t3.medium"
  #   "c6in.xlarge",
  #   #"c6in.4xlarge"
   ]
  # disk_size = 100
  # remote_access {
  #   ec2_ssh_key = data.aws_key_pair.ekscl-sshkey.key_name
  #   source_security_group_ids = [
  #     aws_security_group.bastion-sg.id
  #   ]
  # }

  depends_on = [
    aws_iam_role.eks_node_role,
    #aws_launch_template.eks_launch_template
  ]
  tags = {
    "env"             = "${var.env}"
    "node"            = "${var.nodename}-${var.nodeid}"
    "ISTO_Containers" = "AWS-EKS"

  }

}