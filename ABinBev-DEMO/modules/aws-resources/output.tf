# Print AWS Instance Public
output "aws_ec2_ip" {
  value = aws_instance.ec2_instance[*].private_ip
}
output "vpc_id" {
  value = aws_vpc.VPC_A.id
}

output "subnet_id" {
  value = aws_subnet.subnet-1-vpc[*].id
}