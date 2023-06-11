resource "aws_vpc" "main" {
  cidr_block = var.cidr_block
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = merge(var.tags, {Name = "${var.env}-vpc"})
}

module "subnets" {
  source = "./subnets"
  for_each = var.subnets
  vpc_id   = aws_vpc.main.id
  cidr_block = each.value["cidr_block"]
  name = each.value["name"]
  tags = var.tags
  env = var.env
  azs = each.value["azs"]
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = merge(var.tags, {Name = "${var.env}-igw"})
}

resource "aws_eip" "ngw" {
  count = length(lookup(lookup(var.subnets, "public", null), "cidr_block" , null))
  vpc = true
  tags = merge(var.tags, {Name = "${var.env}-ngw"})
}

resource "aws_nat_gateway" "ngw" {

  count = length(var.subnets["public"].cidr_block)

  allocation_id = aws_eip.ngw[count.index].id

  subnet_id     = module.subnets["public"].subnet_ids[count.index]

  tags = merge(var.tags, {Name = "${var.env}-nip"})

}