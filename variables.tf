variable "env" {
  type        = string
  description = "enviroment suffix"
}

variable "tags" {
  type    = map
  default = {
  }
}

variable "vpc_config"{
  type = object({
    cidr_block            = string
    azs                   = list(string)
    private_subnets       = list(string)
    enable_dns_hostnames  = bool
    enable_dns_support    = bool
  })
  default = {
    cidr_block            = "11.0.0.0/16"
    azs                   = ["us-east-1a", "us-east-1b"]
    private_subnets       = ["11.0.0.0/20", "11.0.16.0/20"]
    enable_dns_hostnames  = true
    enable_dns_support    = true
  }
  description = "EKS vpc configs"
}

variable "eks_cluster" {
  type = object({
    service_ipv4_cidr = string
    public_access_cidrs = list(string)
    endpoint_private_access = bool
    endpoint_public_access = bool
  })
  
  default = {
    service_ipv4_cidr = "10.100.0.0/16" # ClusterIp range assined to Kubernetes's Services
    public_access_cidrs = ["0.0.0.0/0"] # EKS api server allow access
    endpoint_private_access = true
    endpoint_public_access = true
  }
}


variable "eks_node_group_1" {
  type = object({
    capacity_type = string
    instance_types = list(string)
  })
  
  default = {
    capacity_type = "ON_DEMAND" # cheaper option
    instance_types = ["t3.small"] # anything smaller than t3.small may not schedule pods
  }
}