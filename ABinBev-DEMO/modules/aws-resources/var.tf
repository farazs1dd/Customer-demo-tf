
variable "region_aws" {
    type = string
    # default = "london"
}
# variable "alias_aws" {
#     type = string
#     default = "london"
# }
variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
#   default = "10.10.0.0/16"  
}
variable "vpc_tag_name" {
  description = "Tag for VPC"
  type        = string
#   default = { 
#     Name="VPC_x" 
#     }
}

variable "vpc_subnet_cidr" {
  type    = list
#   default = ["user1", "user2", "user3"]
}
# variable "vpc_a_subnet_1_cidr" {
#   description = "CIDR block for VPC A Subnet 1"
#   type        = string
# #   default = "10.10.1.0/24"  
# }

variable "vpc_subnet_az" {
  description = "Availability Zone for VPC x Subnet 1"
  type        = string
#   default = "eu-west-2a"  
}

variable "vpc_subnet_tag_name" {
  description = "Tag for VPC A Subnet 1"
  type        = list
#   default = { 
#     Name="subnet-1-vpc-x" 
#     }
}

variable "vpc_igw_name" {
  description = "Tag for VPC x Internet GW"
  type        = string
#   default = { 
#     Name="VPC_x_IGW" 
#     }
}

variable "vpc_rt_tag_name" {
  description = "Tag for VPC x Route Table"
  type        = string
#   default = { 
#     Name="vpc_a_rt" 
#     }
}

variable "vpc_rt_cidr" {
  description = "CIDR for VPC x Route Table"
  type        = string
#   default = "0.0.0.0/0"
}

variable "instance_ec2_ami" {
  description = "AMI of EC2 instance in VPC x"
  type        = string
#   default = "ami-042fab99b38a3963d"
}
variable "ec2_instance_type" {
  description = "Type of EC2 instance in VPC x"
  type        = string
#   default = "t2.micro"
}

variable "ec2_tag_name" {
    # default = {
    #     Name="AWS_VPC_A_name_x"
    # }
    description = "Tag to apply to the instance in VPC A"
    type = list
  
}
variable "ec2_instance_count" {
    # default = {
    #     Name="AWS_VPC_x_name_x"
    # }
    description = "Count of ec2"
    type = number
  
}

# locals {
#   subnet_ids_list = tolist(data.aws_subnets.current.ids)
  
#   subnet_ids_random_index = random_id.index.dec % length(data.aws_subnets.current.ids)
  
#   instance_subnet_id = local.subnet_ids_list[local.subnet_ids_random_index]
# }
