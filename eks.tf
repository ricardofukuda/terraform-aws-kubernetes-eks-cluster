
resource "aws_eks_cluster" "eks_cluster" {
  name     = "eks-cluster-${var.env}"
  role_arn = aws_iam_role.eks_cluster_role.arn

  kubernetes_network_config {
    service_ipv4_cidr = var.eks_cluster.service_ipv4_cidr
  }

  vpc_config {
    subnet_ids = aws_subnet.eks_private_subnets[*].id
    endpoint_private_access = var.eks_cluster.endpoint_private_access
    endpoint_public_access = var.eks_cluster.endpoint_public_access
    public_access_cidrs = var.eks_cluster.public_access_cidrs
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_role_AmazonEKSClusterPolicy
  ]

  tags = merge(
    var.tags
  )
}

resource "aws_eks_addon" "eks_cluster_addon_coredns" {
  cluster_name = aws_eks_cluster.eks_cluster.name
  addon_name   = "coredns"
  
  depends_on = [
    aws_eks_node_group.eks_node_group_1 # required because coredns only startups properly when there is at least 1 Worker Node
  ]
}

resource "aws_eks_addon" "eks_cluster_addon_kube_proxy" {
  cluster_name = aws_eks_cluster.eks_cluster.name
  addon_name   = "kube-proxy"
}

resource "aws_eks_node_group" "eks_node_group_1" {
  node_group_name = "node-group-1-${var.env}"
  cluster_name    = aws_eks_cluster.eks_cluster.name

  node_role_arn   = aws_iam_role.ec2_eks_node_role.arn
  subnet_ids      = aws_subnet.eks_private_subnets[*].id

  capacity_type   = var.eks_node_group_1.capacity_type
  instance_types  = var.eks_node_group_1.instance_types

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

  lifecycle {
    ignore_changes = [
      scaling_config[0].desired_size
    ]
  }


  depends_on = [
    aws_iam_role_policy_attachment.ec2_eks_node_role_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.ec2_eks_node_role_AmazonEC2ContainerRegistryReadOnly,
    aws_iam_role_policy_attachment.ec2_eks_node_role_AmazonEKS_CNI_Policy
  ]

  tags = merge(
    var.tags
  )
}