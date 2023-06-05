resource "aws_vpc" "main" {
  cidr_block = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support = true
  tag = merge(var.tag, {Name = "${var.env}-vpc"})
}

module "subnets" {
  source = "./subnets"
  for_each = var.subnets
  vpc_id = aws_vpc.main.id
  cidr_block = each.value["cidr_block"]
  env = var.env
  tags = var.tags
  name = each.value["name"]

}