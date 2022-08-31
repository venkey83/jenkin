resource "aws_route_table" "public_route" {
vpc_id = "${aws_vpc.vpc.id}"
route {
cidr_block = "0.0.0.0/0"
gateway_id = "${aws_internet_gateway.igw.id}"
}
/*
route {
cidr_block = "172.32.0.0/16"
vpc_peering_connection_id = "${aws_vpc_peering_connection.primary2secondary.id}"
}
*/
tags = {
Name = "${var.public_routetable_name}"
}
}

locals {
subs = concat([aws_subnet.public_subnet1.id], [aws_subnet.public_subnet2.id])
}
resource "aws_route_table_association" "pubrtassociation" {
route_table_id = "${aws_route_table.public_route.id}"
subnet_id = element(local.subs,count.index)
count = "2"
}
