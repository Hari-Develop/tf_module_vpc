resource "aws_subnet" "main" {
  count = length(var.cidr_block)
  vpc_id     = var.vpc_id
  cidr_block = var.cidr_block[count.index]
  avavailability_zone = var.azs[count.index]
  tags = merge(var.tag, {Name = "${var.env}-${var.name}-subnet-${count.index + 1}"})

}

resource "aws_route_table" "main" {
  count = length(var.cidr_block)
  vpc_id = aws_vpc.main.id
  tags = merge(var.tag, {Name = "${var.env}-${var.name}-rwt-${count.index + 1}"})
}

resource "aws_route_table_association" "route_association" {
  count = length(var.cidr_block)
  subnet_id      = aws_subnet.main[count.index].id
  route_table_id = aws_route_table.main[count.index].id
}