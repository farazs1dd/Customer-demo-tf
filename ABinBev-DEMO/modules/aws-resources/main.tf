provider "aws" {
  region = var.region_aws
}


# Create VPC
resource "aws_vpc" "VPC_A" {
  cidr_block = var.vpc_cidr
  instance_tenancy = "default"
  tags = {
    Name = var.vpc_tag_name
  }
}

# Create Subnet

resource "aws_subnet" "subnet-1-vpc" {

  count                   = "${length(var.vpc_subnet_cidr)}"
  vpc_id                  = aws_vpc.VPC_A.id
  cidr_block              = "${var.vpc_subnet_cidr[count.index]}"
  availability_zone       = var.vpc_subnet_az
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.vpc_subnet_tag_name[count.index]}"
  }
}

#Create IGW
##############

resource "aws_internet_gateway" "vpc_a_igw" {
 vpc_id = aws_vpc.VPC_A.id
 tags = {
    Name = var.vpc_igw_name
 }
}


#Create RouteTable
#############################

resource "aws_route_table" "vpc_a_rt" {
  vpc_id = aws_vpc.VPC_A.id
  tags = {
    Name = var.vpc_rt_tag_name
  }

  route {
    # Associated subnet can reach public internet
    cidr_block =var.vpc_rt_cidr

    # Which internet gateway to use
    gateway_id = aws_internet_gateway.vpc_a_igw.id
  }
}


# Create a Route Table Association
resource "aws_route_table_association" "rt_association_1" {
  count                   = "${length(var.vpc_subnet_cidr)}"
  route_table_id = aws_route_table.vpc_a_rt.id
  subnet_id      = aws_subnet.subnet-1-vpc[count.index].id
}

# Create a Route Default Route
resource "aws_route" "route_igw" {
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.vpc_a_igw.id
  route_table_id  = aws_route_table.vpc_a_rt.id
}
# Create Security Group

resource "aws_security_group" "vpc_a_sg" {
  vpc_id      = aws_vpc.VPC_A.id

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "ICMP"
    from_port        = -1
    to_port          = -1
    protocol         = "icmp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}




# CREATE VM 
############
resource "aws_instance" "ec2_instance" {
    count = var.ec2_instance_count
    ami           = var.instance_ec2_ami
    instance_type = var.ec2_instance_type
    subnet_id     = aws_subnet.subnet-1-vpc[count.index].id
    associate_public_ip_address = false
    vpc_security_group_ids = [aws_security_group.vpc_a_sg.id]
    tags = {
      Name = "${var.ec2_tag_name[count.index]}"
    }
  }

