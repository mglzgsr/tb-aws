resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_vpc_attachment" {
  #count = length(var.account_id) > 0 ? 1 : 0
  subnet_ids         = var.subnets_ids
  transit_gateway_id = var.transit_gateway_id
  vpc_id             = var.vpc_id
  tags = merge(
  {
    "Name" = format("AWSLZ_TWG_VPC_%s", var.account_id)
  },
  var.tags
  )
}