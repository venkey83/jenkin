vpc_cidr = "20.20.0.0/16"
dnshostname = "true"
vpc_name = "innovative-dev"
public_subnet1_cidr = "20.20.10.0/24"
public_subnet2_cidr = "20.20.60.0/24"
auto_publicip_assign = "true"
private_subnet1_cidr = "20.20.90.0/24"
private_subnet2_cidr = "20.20.120.0/24"
public_subnet1_name = "dev-pubsub1"
public_subnet2_name = "dev-pubsub2"
private_subnet1_name = "dev-prt-sub-1"
private_subnet2_name = "dev-prt-sub-2"
igw_name = "dev-igw"
public_routetable_name = "dev-pub-rt"
private_routetable_name = "dev-prt-rt"


#########server variable#########
instance_type = "t3.small"
ami = "ami-0f36dcfcc94112ea1"
keyname = "innovative-dev"
ec2_termination_protection = "true"
detail_monitoring = "false"
iam_role = "admin"
userdata = "test.sh"
root_volume_encryption = "false"
root_volume_name = "innovative-dev"
root_volume_size = "20"
root_volume_type = "gp2"
ec2_name = "innovative-dev-server"
#ec2_subnet = "aws_subnet.public_subnet1.id"
#ec2_subnet = "${aws_subnet.public_subnet1.id}"
