
resource "aws_vpc" "eks" {
  cidr_block             = var.vpc_config.cidr_block
  enable_dns_hostnames   = var.vpc_config.enable_dns_hostnames
  enable_dns_support     = var.vpc_config.enable_dns_support

  tags = merge(
    { "Name" = "eks-${var.env}" },
    var.tags
  )
}

resource "aws_subnet" "eks_private_subnets" {
  count                   = length(var.vpc_config.private_subnets)

  vpc_id                  = aws_vpc.eks.id
  cidr_block              = element(var.vpc_config.private_subnets, count.index)
  availability_zone       = element(var.vpc_config.azs, count.index)
  map_public_ip_on_launch =  true # workaround for not using nat gateway

  lifecycle {
    create_before_destroy = false
  }

  tags = merge(
    { "Name" = "eks-private-${element(var.vpc_config.azs, count.index)}-${var.env}" },
    var.tags
  )
}

resource "aws_internet_gateway" "eks_igw" {
  vpc_id = aws_vpc.eks.id

  tags = merge(
    { "Name" = "igw-eks-${var.env}" },
    var.tags
  )
}


resource "aws_default_route_table" "eks_vpc_rt" {
  default_route_table_id  = aws_vpc.eks.default_route_table_id
  propagating_vgws        = []

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.eks_igw.id
  }

  tags = merge(
    { "Name" = "rt-eks-vpc-${var.env}" },
    var.tags
  )
}