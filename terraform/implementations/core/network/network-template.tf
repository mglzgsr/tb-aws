#Create TGW
module "aws_lz_tgw" {
  source = "./modules/transit-gateway/tgw-main"

  providers = {
    aws = aws.network-account
  }

  name            = format("aws_lz_tgw_%s",local.network_account_id)
  description     = "AWS Landing Zone TGW shared with several other AWS accounts"
  amazon_side_asn = 64599

  enable_auto_accept_shared_attachments = true
  tags = { (var.tag_key_project_id) = var.awslz_proj_id, (var.tag_key_environment) = var.awslz_environment, (var.tag_key_account_id) = local.network_account_id, (var.tag_key_name) = "network" }
}

module "aws_lz_aws_ram_share_tg" {
  source = "./modules/ram"

  ram_name = "aws_lz_ram_tgw"
  ram_allow_external_principals = false
  ram_resource_arn = module.aws_lz_tgw.tgw_arn
  ram_principals =  module.aws_lz_organization_main.org_arn
  ram_tags = { (var.tag_key_project_id) = var.awslz_proj_id, (var.tag_key_environment) = var.awslz_environment, (var.tag_key_account_id) = module.aws_lz_organization_main.master_account_id, (var.tag_key_name) = "aws-ram-tg" }

  providers = {
    aws = aws.network-account
  }
}

### </ Egress VPC
module "aws_lz_egress_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 2.0"

  providers = {
    aws = aws.network-account
  }

  name = var.egress_vpc_name

  cidr = var.egress_vpc_cidr

  azs             = [local.primary_az,local.secondary_az]
  public_subnets  = var.egress_vpc_public_subnets
  private_subnets = var.egress_vpc_private_subnets

  enable_nat_gateway = true
  single_nat_gateway = false
  one_nat_gateway_per_az = true

  tags = { (var.tag_key_project_id) = var.awslz_proj_id, (var.tag_key_environment) = var.awslz_environment, (var.tag_key_account_id) = local.network_account_id, (var.tag_key_name) = "network" }
}

module "aws_lz_egress_vpc_twg_attachment" {
  source  = "./modules/transit-gateway/tgw-vpc-attachment"

  providers = {
    aws = aws.network-account
  }

  attach_name = format("aws_lz_egress_vpc_attach_%s",local.network_account_id)
  transit_gateway_id = module.aws_lz_tgw.tgw_id
  vpc_id = module.aws_lz_egress_vpc.vpc_id
  subnets_ids =  module.aws_lz_egress_vpc.private_subnets
  tags = { (var.tag_key_project_id) = var.awslz_proj_id, (var.tag_key_environment) = var.awslz_environment, (var.tag_key_account_id) = local.network_account_id, (var.tag_key_name) = "network" }
}

module "aws_lz_tgw_route" {
  source = "./modules/transit-gateway/tgw-route-table/tgw-routes"

  providers = {
    aws = aws.network-account
  }

  route_table_id = "default"
  destination_cidr_block = "0.0.0.0/0"
  tgw_id = module.aws_lz_tgw.tgw_id
  attach_id = module.aws_lz_egress_vpc_twg_attachment.tgw_attach_id
}

### Route Table DEV
module "aws_lz_tgw_route_table_dev" {
  source = "./modules/transit-gateway/tgw-route-table"

  providers = {
    aws = aws.network-account
  }

  route_table_name = "aws_lz_tgw_route_table_dev"
  tgw_id = module.aws_lz_tgw.tgw_id
  tags = { (var.tag_key_project_id) = var.awslz_proj_id, (var.tag_key_environment) = var.awslz_environment, (var.tag_key_account_id) = local.network_account_id, (var.tag_key_name) = "network" }

}

module "aws_lz_tgw_route_dev" {
  source = "./modules/transit-gateway/tgw-route-table/tgw-routes"

  providers = {
    aws = aws.network-account
  }

  route_table_id = module.aws_lz_tgw_route_table_dev.tgw_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  tgw_id = module.aws_lz_tgw.tgw_id
  attach_id = module.aws_lz_egress_vpc_twg_attachment.tgw_attach_id
}
###

### Route Table TEST
module "aws_lz_tgw_route_table_test" {
  source = "./modules/transit-gateway/tgw-route-table"

  providers = {
    aws = aws.network-account
  }

  route_table_name = "aws_lz_tgw_route_table_test"
  tgw_id = module.aws_lz_tgw.tgw_id
  tags = { (var.tag_key_project_id) = var.awslz_proj_id, (var.tag_key_environment) = "TEST", (var.tag_key_account_id) = local.network_account_id, (var.tag_key_name) = "network" }

}

module "aws_lz_tgw_route_test" {
  source = "./modules/transit-gateway/tgw-route-table/tgw-routes"

  providers = {
    aws = aws.network-account
  }

  route_table_id = module.aws_lz_tgw_route_table_test.tgw_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  tgw_id = module.aws_lz_tgw.tgw_id
  attach_id = module.aws_lz_egress_vpc_twg_attachment.tgw_attach_id
}

###

###Route Table PROD
module "aws_lz_tgw_route_table_prod" {
  source = "./modules/transit-gateway/tgw-route-table"

  providers = {
    aws = aws.network-account
  }

  route_table_name = "aws_lz_tgw_route_table_prod"
  tgw_id = module.aws_lz_tgw.tgw_id
  tags = { (var.tag_key_project_id) = var.awslz_proj_id, (var.tag_key_environment) = "PROD", (var.tag_key_account_id) = local.network_account_id, (var.tag_key_name) = "network" }

}

module "aws_lz_tgw_route_prod" {
  source = "./modules/transit-gateway/tgw-route-table/tgw-routes"

  providers = {
    aws = aws.network-account
  }

  route_table_id = module.aws_lz_tgw_route_table_prod.tgw_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  tgw_id = module.aws_lz_tgw.tgw_id
  attach_id = module.aws_lz_egress_vpc_twg_attachment.tgw_attach_id
}
###

##VPC Routes
module "aws_lz_tgw_egress_vpc_route"{
  source  = "./modules/route"
  providers = {
    aws = aws.network-account
  }
  route_table = module.aws_lz_egress_vpc.public_route_table_ids
  destination = var.tgw_vpc_internal_traffic_cidr
  transit_gateway = module.aws_lz_tgw.tgw_id
}
### Egress VPC />

### </ Ingress VPC
module "aws_lz_ingress_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 2.0"

  providers = {
    aws = aws.network-account
  }

  name = var.ingress_vpc_name

  cidr = var.ingress_vpc_cidr

  azs             = [local.primary_az,local.secondary_az]
  public_subnets  = var.ingress_vpc_public_subnets
  private_subnets = var.ingress_vpc_private_subnets

  enable_nat_gateway = false
  single_nat_gateway = false
  one_nat_gateway_per_az = false

  # Required tags for EKS
  private_subnet_tags = {"kubernetes.io/role/internal-elb" = 1}
  public_subnet_tags = {"kubernetes.io/role/elb" = 1}

  tags = { (var.tag_key_project_id) = var.awslz_proj_id, (var.tag_key_environment) = var.awslz_environment, (var.tag_key_account_id) = local.network_account_id, (var.tag_key_name) = "network", "kubernetes.io/cluster/${var.ingress_eks_cluster_name}" = "shared"}
}

module "aws_lz_ingress_vpc_twg_attachment" {
  source  = "./modules/transit-gateway/tgw-vpc-attachment"

  providers = {
    aws = aws.network-account
  }

  attach_name = format("aws_lz_ingress_vpc_attach_%s",local.network_account_id)
  transit_gateway_id = module.aws_lz_tgw.tgw_id
  vpc_id = module.aws_lz_ingress_vpc.vpc_id
  subnets_ids =  module.aws_lz_ingress_vpc.private_subnets
  tags = { (var.tag_key_project_id) = var.awslz_proj_id, (var.tag_key_environment) = var.awslz_environment, (var.tag_key_account_id) = local.network_account_id, (var.tag_key_name) = "network" }
}

##Routes
module "aws_lz_tgw_internet_ingress_vpc_route"{
  source  = "./modules/route"
  providers = {
    aws = aws.network-account
  }
  route_table = module.aws_lz_ingress_vpc.private_route_table_ids
  destination = var.tgw_vpc_internet_cidr
  transit_gateway = module.aws_lz_tgw.tgw_id
}

module "aws_lz_tgw_ingress_vpc_route"{
  source  = "./modules/route"
  providers = {
    aws = aws.network-account
  }
  route_table = module.aws_lz_ingress_vpc.private_route_table_ids
  destination = var.tgw_vpc_internal_traffic_cidr
  transit_gateway = module.aws_lz_tgw.tgw_id
}
### Ingress VPC />

#Security Group
# Security group for bastion ssh access
module "network_bastion_internal_access_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "3.4.0"
  
  providers = {
    aws = aws.network-account
  }
  name = var.network_bastion_internal_access_security_group_name
  description = var.network_bastion_internal_access_security_group_description
  vpc_id = module.aws_lz_ingress_vpc.vpc_id

  ingress_cidr_blocks = var.internal_ingress_cidr_blocks
  ingress_rules       = var.network_bastion_internal_access_ingress_rules
  egress_rules        = var.all_all_egress_rules

  tags = { (var.tag_key_project_id) = var.awslz_proj_id, (var.tag_key_environment) = var.awslz_environment, (var.tag_key_account_id) = local.network_account_id, (var.tag_key_name) = "network" }
}

# Nginx Reverse proxy
module "network_reverse_proxy_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "3.4.0"
  
  providers = {
    aws = aws.network-account
  }
  name = var.network_reverse_proxy_security_group_name
  description = var.network_reverse_proxy_security_group_description
  vpc_id = module.aws_lz_ingress_vpc.vpc_id

  ingress_cidr_blocks = var.internet_ingress_cidr_blocks
  ingress_rules       = var.network_reverse_proxy_ingress_rules
  egress_rules        = var.all_all_egress_rules

  tags = { (var.tag_key_project_id) = var.awslz_proj_id, (var.tag_key_environment) = var.awslz_environment, (var.tag_key_account_id) = local.network_account_id, (var.tag_key_name) = "network" }
}

# Bastion
module "bastion_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "3.4.0"
  
  providers = {
    aws = aws.network-account
  }
  name = var.bastion_security_group_name
  description = var.bastion_security_group_description
  vpc_id = module.aws_lz_ingress_vpc.vpc_id

  ingress_cidr_blocks = var.internet_ingress_cidr_blocks
  ingress_rules       = var.bastion_ingress_rules
  egress_rules        = var.all_all_egress_rules

  tags = { (var.tag_key_project_id) = var.awslz_proj_id, (var.tag_key_environment) = var.awslz_environment, (var.tag_key_account_id) = local.network_account_id, (var.tag_key_name) = "network" }
}
#END Security Groups

#SECURITY ROLES
 module "aws_lz_iam_security_admin_network" {
   source = "./modules/iam"
 
   providers = {
     aws = aws.network-account
   }

   role_name = local.security_role_name
   assume_role_policy = data.aws_iam_policy_document.aws_lz_assume_role_security.json
   role_tags = { (var.tag_key_project_id) = var.awslz_proj_id, (var.tag_key_environment) = var.awslz_environment, (var.tag_key_account_id) = local.network_account_id }

   #attachment
  role_policy_attach = true
  policy_arn = local.administrator_access_arn

 }

  module "aws_lz_iam_security_audit_network" {
   source = "./modules/iam"
   providers = {
     aws = aws.network-account
   }

   role_name = local.security_role_name_audit
   assume_role_policy = data.aws_iam_policy_document.aws_lz_assume_role_security.json
   role_tags = { (var.tag_key_project_id) = var.awslz_proj_id, (var.tag_key_environment) = var.awslz_environment, (var.tag_key_account_id) = local.network_account_id }
   #attachment
   role_policy_attach = true
   policy_arn = local.read_only_access_arn

  }

### BEGIN VPN Connection modules -->
# Create Customer Gateway
  module "aws_lz_customer_gateway" {
    source = "./modules/vpn/customer-gateway"
    providers = {
      aws = aws.network-account
    }

    cgw_name = format("aws_lz_cgw_%s",local.network_account_id)
    create_cgw = var.create_vpn
    bgn_asn = var.cgw_bgn_asn
    customer_ip_address = var.cgw_ip_address
    cgw_type = var.cgw_type

    tags = { (var.tag_key_project_id) = var.awslz_proj_id, (var.tag_key_environment) = var.awslz_environment, (var.tag_key_account_id) = local.network_account_id, (var.tag_key_name) = "network" }

  }

###Create VPN Connection
  module "aws_lz_vpn_connection" {
    source = "./modules/transit-gateway/tgw-vpn-attachment"
    providers = {
      aws = aws.network-account
    }

    vpn_attach_name = format("aws_lz_vpn_tgw_attachment_%s",local.network_account_id)
    create_vpn_connection = var.create_vpn
    cgw_id = module.aws_lz_customer_gateway.cgw_id
    tgw_id = module.aws_lz_tgw.tgw_id
    cgw_type = module.aws_lz_customer_gateway.cgw_type
    cgw_static_route = var.cgw_static_route

    tags = { (var.tag_key_project_id) = var.awslz_proj_id, (var.tag_key_environment) = var.awslz_environment, (var.tag_key_account_id) = local.network_account_id, (var.tag_key_name) = "network" }

  }
### END VPN Connection <--


# Create EKS cluster
module "ingress_eks_cluster" {
  source = "./modules/eks"
  providers = {
    aws = aws.network-account
  }

  eks_iam_role_name         = var.ingress_eks_role_name
  subnets                   = module.aws_lz_ingress_vpc.public_subnets
  eks_cluster_name          = var.ingress_eks_cluster_name

  node_group_name           = var.ingress_eks_node_group_name
  node_group_role_name      = var.ingress_eks_node_group_role_name
  node_group_subnets        = module.aws_lz_ingress_vpc.private_subnets
  node_group_instance_types = var.ingress_eks_node_group_instance_types
}
# END Create EKS cluster


# Key pair
module "network_account_keypair" {
  source = "./modules/key-pairs"
  providers = {
    aws = aws.network-account
  }

  key_name    = var.deployment_key_name
  public_key  = var.env_deployment_key
  tags        = { generation_date = var.env_generation_date } 
}
# END Key pair


### </ In-line VPC

module "aws_lz_inline_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 2.0"

  providers = {
    aws = aws.network-account
  }

  name = var.inline_vpc_name

  cidr = var.inline_vpc_cidr

  azs             = [local.primary_az,local.secondary_az]
  public_subnets  = var.inline_vpc_public_subnets
  private_subnets = var.inline_vpc_private_subnets

  tags = { (var.tag_key_project_id) = var.awslz_proj_id, (var.tag_key_environment) = var.awslz_environment, (var.tag_key_account_id) = local.network_account_id, (var.tag_key_name) = "network", "kubernetes.io/cluster/${var.ingress_eks_cluster_name}" = "shared"}
}

module "aws_lz_inline_vpc_twg_attachment" {
  source  = "./modules/transit-gateway/tgw-vpc-attachment"

  providers = {
    aws = aws.network-account
  }

  attach_name = format("aws_lz_inline_vpc_attach_%s",local.network_account_id)
  transit_gateway_id = module.aws_lz_tgw.tgw_id
  vpc_id = module.aws_lz_inline_vpc.vpc_id
  subnets_ids =  module.aws_lz_inline_vpc.private_subnets
  tags = { (var.tag_key_project_id) = var.awslz_proj_id, (var.tag_key_environment) = var.awslz_environment, (var.tag_key_account_id) = local.network_account_id, (var.tag_key_name) = "network" }
}


##In-line VPC Routes
module "aws_lz_tgw_internet_inline_vpc_route"{
  source  = "./modules/route"
  providers = {
    aws = aws.network-account
  }
  route_table = module.aws_lz_inline_vpc.private_route_table_ids
  destination = var.tgw_vpc_internet_cidr
  transit_gateway = module.aws_lz_tgw.tgw_id
}

module "aws_lz_tgw_inline_vpc_route"{
  source  = "./modules/route"
  providers = {
    aws = aws.network-account
  }
  route_table = module.aws_lz_inline_vpc.private_route_table_ids
  destination = var.tgw_vpc_internal_traffic_cidr
  transit_gateway = module.aws_lz_tgw.tgw_id
}
### END In-line VPC />


#EC2 Instances
# NGINX Reverse proxy
module "network_reverse_proxy_ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "2.13.0"
  providers = {
    aws = aws.network-account
  }
  name = var.network_reverse_proxy_instance_name
  ami = var.ubuntu18_04_ami_version
  instance_type = var.t2_micro_instance_type
  subnet_id = element(tolist(module.aws_lz_ingress_vpc.public_subnets),0)
  vpc_security_group_ids = list(module.network_reverse_proxy_security_group.this_security_group_id, module.network_bastion_internal_access_security_group.this_security_group_id)
  user_data = replace(file("../automation/user_data_scripts/ubuntu_nginx.sh"),"internal_server_ip",element(tolist(module.sandbox_web_server_ec2_instance.private_ip),0))
  key_name = module.network_account_keypair.key_name
  private_ip = var.network_reverse_proxy_private_ip
  disable_api_termination = true
  tags = { (var.tag_key_project_id) = var.awslz_proj_id, (var.tag_key_environment) = var.awslz_environment, (var.tag_key_account_id) = local.network_account_id, (var.tag_key_name) = "network" }
}


# Bastion
module "ec2_instance_bastion" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "2.13.0"
  providers = {
    aws = aws.network-account
  }
  name = var.bastion_instance_name
  ami = var.bastion_ami_version
  instance_type = var.t2_micro_instance_type
  subnet_id = element(tolist(module.aws_lz_ingress_vpc.public_subnets),0)
  vpc_security_group_ids = list(module.bastion_security_group.this_security_group_id)
  #user_data = replace(file("../automation/user_data_scripts/ubuntu_nginx.sh"),"internal_server_ip",element(tolist(module.ec2_instance.private_ip),0))
  key_name = module.network_account_keypair.key_name #var.network_account_key_name
  disable_api_termination = true
  tags = { (var.tag_key_project_id) = var.awslz_proj_id, (var.tag_key_environment) = var.awslz_environment, (var.tag_key_account_id) = local.network_account_id, (var.tag_key_name) = "network" }
}
# END EC2 Instances

#Security Group
# NetMon Reverse proxy
module "netmon_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "3.4.0"

  providers = {
    aws = aws.network-account
  }
  name = var.netmon_security_group_name
  description = var.netmon_security_group_description
  vpc_id = module.aws_lz_inline_vpc.vpc_id

  ingress_cidr_blocks = var.internet_ingress_cidr_blocks
  ingress_rules       = var.netmon_ingress_rules
  egress_rules        = var.all_all_egress_rules

  tags = { (var.tag_key_project_id) = var.awslz_proj_id, (var.tag_key_environment) = var.awslz_environment, (var.tag_key_account_id) = local.network_account_id, (var.tag_key_name) = "network" }
}

locals {
  user_data_raw = file("../automation/user_data_scripts/nagios_install.sh")
}

# Network Monitoring Server
module "aws_lz_net_monitor_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "2.13.0"
  providers = {
    aws = aws.network-account
  }
  name = var.netmon_instance_name
  ami = var.amzn2_ami_version
  instance_type = var.t2_micro_instance_type
  subnet_id = element(module.aws_lz_inline_vpc.private_subnets,0)
  private_ip = var.netmon_reverse_proxy_private_ip
  vpc_security_group_ids = [module.netmon_security_group.this_security_group_id]
  user_data = replace(file("../automation/user_data_scripts/nagios_install.sh"),"NETMON_EMAIL",var.email_netmon)
  key_name = module.network_account_keypair.key_name
  disable_api_termination = true
  tags = { (var.tag_key_project_id) = var.awslz_proj_id, (var.tag_key_environment) = var.awslz_environment, (var.tag_key_account_id) = local.network_account_id, (var.tag_key_name) = "network" }
}

###Network Manager
###Create Global Network
module "aws_lz_create_global_network" {
  source = "./modules/transit-gateway/tgw-net-manager"
  providers = {
    aws = aws.network-account
  }
  global_network_name = "aws_lz_global_network"
  tags = { (var.tag_key_project_id) = var.awslz_proj_id, (var.tag_key_environment) = var.awslz_environment, (var.tag_key_account_id) = local.network_account_id, (var.tag_key_name) = "network" }
}