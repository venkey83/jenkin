resource "aws_vpc" "vpc" {
cidr_block = "${var.vpc_cidr}"
enable_dns_hostnames = "${var.dnshostname}"
tags = {
Name = "${var.vpc_name}"
}
}


data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "public_subnet1" {
vpc_id = "${aws_vpc.vpc.id}"
cidr_block = "${var.public_subnet1_cidr}"
map_public_ip_on_launch = "${var.auto_publicip_assign}"
availability_zone = data.aws_availability_zones.available.names[0]
tags = {
Name = "${var.public_subnet1_name}"
}
}

resource "aws_subnet" "public_subnet2" {
vpc_id = "${aws_vpc.vpc.id}"
cidr_block = "${var.public_subnet2_cidr}"
map_public_ip_on_launch = "${var.auto_publicip_assign}"
availability_zone = data.aws_availability_zones.available.names[1]
tags = {
Name = "${var.public_subnet2_name}"
}
}

resource "aws_subnet" "private_subnet1" {
vpc_id = "${aws_vpc.vpc.id}"
cidr_block = "${var.private_subnet1_cidr}"
map_public_ip_on_launch = "false"
availability_zone = data.aws_availability_zones.available.names[0]
tags = {
Name = "${var.private_subnet1_name}"
}
}

resource "aws_subnet" "private_subnet2" {
vpc_id = "${aws_vpc.vpc.id}"
cidr_block = "${var.private_subnet2_cidr}"
map_public_ip_on_launch = "false"
availability_zone = data.aws_availability_zones.available.names[1]
tags = {
Name = "${var.private_subnet2_name}"
}
}


resource "aws_internet_gateway" "igw" {
vpc_id = "${aws_vpc.vpc.id}"
tags = {
Name = "${var.igw_name}"
}
}


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

#######public-rt-association#####

locals {
subs = concat([aws_subnet.public_subnet1.id], [aws_subnet.public_subnet2.id])
}
resource "aws_route_table_association" "pubrtassociation" {
route_table_id = "${aws_route_table.public_route.id}"
subnet_id = element(local.subs,count.index)
count = "2"
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


#resource "aws_security_group" "sg"


