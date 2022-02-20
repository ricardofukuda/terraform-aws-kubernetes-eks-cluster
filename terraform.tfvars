env = "dev"

tags = {
  Environment = "dev"
}

vpc_config = {
  cidr_block            = "11.0.0.0/16"
  azs                   = ["us-east-1a", "us-east-1b"]
  private_subnets       = ["11.0.0.0/20", "11.0.16.0/20"]
  enable_dns_hostnames  = true
  enable_dns_support    = true
}

eks_cluster = {
  service_ipv4_cidr = "10.100.0.0/16" # ClusterIp range assined to Kubernetes's Services
  public_access_cidrs = ["0.0.0.0/0"] # EKS api server allow access
  endpoint_private_access = true
  endpoint_public_access = true
}

eks_node_group_1= {
  capacity_type = "SPOT" # cheaper option
  instance_types = ["t3.small"]
}