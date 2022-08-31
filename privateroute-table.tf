resource "aws_route_table" "private_routetable" {
vpc_id = "${aws_vpc.vpc.id}"
/*
route {
cidr_block = "0.0.0.0/0"
nat_gateway_id = "${aws_nat_gateway.nat.id}"
}
*/
tags = {
Name = "${var.private_routetable_name}"
}
}


#######pr-rt-association#####
locals {
prsubs = concat([aws_subnet.private_subnet1.id], [aws_subnet.private_subnet2.id])
}
resource "aws_route_table_association" "prrtassociation" {
route_table_id = "${aws_route_table.private_routetable.id}"
subnet_id = element(local.prsubs,count.index)
count = "2"
}
