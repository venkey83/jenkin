/*
output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.ec2.id
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.ec2.public_ip
}

output "instance_private_ip" {
  description = "Private IP address of the EC2 instance"
  value       = aws_instance.ec2.private_ip
}
*/


output "security_group_id" {
 description = "ID of the vpc-sg"
  value = aws_security_group.allow_tls.id
}

output "vpc_id" {
  description = "ID of the vpc"
  value       = aws_vpc.vpc.id

}
