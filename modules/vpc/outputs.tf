output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_subnet_ids" {
  value = ["${aws_subnet.public_subnet.*.id}"]
}

output "private_subnet_ids" {
  value = ["${aws_subnet.private_subnet.*.id}"]
}


output "private_security_group" {
  value = aws_security_group.private_vpc_sg.id
}


output "public_route_table" {
  value = aws_route_table.public_subnet_rtb[*].id
}

output "private_route_tables" {
  value = aws_route_table.private_subnet_rtb[*].id
}

output "nat_gateway_ips" {
  value = aws_eip.nat_eip[*].public_ip
}

