data "aws_subnets" "subnet" {
  filter {
    name   = "tag:Name"
    values = ["dev-pubsub*"] # insert values here
  }
}




resource "aws_instance" "ec2" {
  for_each      = toset(data.aws_subnets.subnet.ids)
  instance_type          = "${var.instance_type}"
  ami                    =  "${var.ami}"
  #key_name               = "${var.keyname}"
  #subnet_id              = "${var.ec2_subnet}"
  #subnet_id              = "${aws_subnet.public_subnet1.id}"
  subnet_id              = "each.value"
  disable_api_termination = "${var.ec2_termination_protection}"
   #vpc_security_group_ids = "${[aws_security_group.primary-default.id]}"
  #monitoring		 = "${var.detail_monitoring}"
  iam_instance_profile   = "${var.iam_role}"
  #user_data		= "${file("${var.userdata}")}"
  
   root_block_device {
        delete_on_termination = true
       # device_name           = "/dev/sda1"
        encrypted             = "${var.root_volume_encryption}"
        #iops                  = 100
        tags                  = {
         Name = "${var.root_volume_name}"
                     }
        volume_size           = "${var.root_volume_size}"
        volume_type           = "${var.root_volume_type}"
    }
  
tags = {
 Name = "${var.ec2_name}"
}
}

  
/*
disable_api_termination              = 
vpc_security_group_ids = [aws_security_group.primary-default.id]
#  vpc_security_group_ids = []
#availability_zone
#monitoring
#private_ip
ebs_block_device {
          + delete_on_termination = (known after apply)
          + device_name           = (known after apply)
          + encrypted             = (known after apply)
          + iops                  = (known after apply)
          + kms_key_id            = (known after apply)
          + snapshot_id           = (known after apply)
          + tags                  = (known after apply)
          + throughput            = (known after apply)
          + volume_id             = (known after apply)
        #  + volume_size           = (known after apply)
          + volume_type           = (known after apply)
        #}
root_block_device {
          + delete_on_termination = (known after apply)
          + device_name           = (known after apply)
          + encrypted             = (known after apply)
          + iops                  = (known after apply)
          + kms_key_id            = (known after apply)
          + tags                  = (known after apply)
          + throughput            = (known after apply)
          + volume_id             = (known after apply)
          + volume_size           = (known after apply)
          + volume_type           = (known after apply)
        }
*/
