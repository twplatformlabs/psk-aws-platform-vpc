module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.21.0"

  name = "${var.cluster_name}-vpc"
  cidr = var.vpc_cidr
  azs  = var.vpc_azs

  # private, node subnet
  private_subnets       = var.vpc_private_subnets
  private_subnet_suffix = "private-subnet"
  private_subnet_tags   = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "Tier"                                      = "node"
    "karpenter.sh/discovery"                    = "${var.cluster_name}-vpc"
  }

  # public ingress subnet
  public_subnets       = var.vpc_public_subnets
  public_subnet_suffix = "public-subnet"
  public_subnet_tags   = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                    = "1"
    "Tier"                                      = "public"
  }

  # intra, non-outbound route subnet
  intra_subnets       = var.vpc_intra_subnets
  intra_subnet_suffix = "intra-subnet"
  intra_subnet_tags   = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "Tier"                                      = "intra"
  }

  # dedicated cluster database subnet
  database_subnets       = var.vpc_database_subnets
  database_subnet_suffix = "database-subnet"
  database_subnet_tags   = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "Tier"                                      = "database"
  }

  create_database_subnet_group    = true
  create_elasticache_subnet_group = false
  create_redshift_subnet_group    = false

  map_public_ip_on_launch = false
  enable_dns_hostnames    = true
  enable_dns_support      = true
  enable_nat_gateway      = true
  single_nat_gateway      = true

  # Cloudwatch log group and IAM role will be created
  # enable_flow_log                      = true
  # create_flow_log_cloudwatch_log_group = true
  # create_flow_log_cloudwatch_iam_role  = true
  # flow_log_max_aggregation_interval    = 60

  # vpc_flow_log_tags = {
  #   Name = "vpc-flow-logs-cloudwatch-logs-default"
  # }
}



# if you implement a multi-region EP networking pattern using AWS Cloud WAN
# The below example assumes automatic cross segment routing only for the intra subnet
# when it is used as an internal ingress network for a cluster (typically also on a secondary CIDR)
#
# data "terraform_remote_state" "wan" {
#   backend = "remote"
#
#   config = {
#     "organization" : "rba",
#     "workspaces" : {
#       "name" : "psk-aws-platform-wan-${var.infra_env}"
#     }
#   }
# }

# resource "aws_networkmanager_vpc_attachment" "cwan" {
#   core_network_id = data.terraform_remote_state.wan.outputs.core_network_id
#   subnet_arns     = module.segment_region_vpc.intra_subnet_arns
#   vpc_arn         = module.segment_region_vpc.vpc_arn
#
#   tags = {
#     "Tier"    = "intra"
#     "segment" = var.segment
#   }
# }

# resource "aws_route" "public_to_cwan" {
#   core_network_arn       = data.terraform_remote_state.wan.outputs.core_network_arn
#   destination_cidr_block = "10.0.0.0/8"
#   route_table_id         = module.segment_region_vpc.public_route_table_ids[0]
#   depends_on             = [aws_networkmanager_vpc_attachment.cwan]
# }

# resource "aws_route" "private_to_cwan" {
#   count                  = length(var.vpc_azs)
#   core_network_arn       = data.terraform_remote_state.wan.outputs.core_network_arn
#   destination_cidr_block = "10.0.0.0/8"
#   route_table_id         = module.segment_region_vpc.private_route_table_ids[count.index]
#   depends_on             = [aws_networkmanager_vpc_attachment.cwan]
# }
