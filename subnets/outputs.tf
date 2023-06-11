output "subnet_ids" {
  value = aws_subnet.main.*.id
}

//output "subnet_cidr_block" {
 // value = aws_subnet.main.*.block
//}

output "route_table_ids" {
  value = aws_route_table.main.*.id
}