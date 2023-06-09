resource "aws_vpc" "main" {
  cidr_block = var.cidr_block
  env = var.env
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = merge(var.tag, {Name = "${var.env}-vpc"})
}