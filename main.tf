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
  azs = each.value["azs"]
  env = var.env
  tags = var.tags
  name = each.value["name"]
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tag = merge(var.tag, {Name = "${var.env}-igw"})
}

resource "aws_eip" "ngw" {
  count = length(var.subnets["public"].cidr_block)
  vpc = true
  tag = merge(var.tag, {Name = "${var.env}-ngw"})
}

resource "aws_nat_gateway" "ngw" {
  count = length(var.subnets["public"].cidr_block)
  allocation_id = aws_eip.ngw[count.index].id
  subnet_id     = module.subnets["public"].subnet_ids[count.index]

  tag = merge(var.tag, {Name = "${var.env}-ngw"})

}