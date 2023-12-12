# #Prosimo Infra for AWS

# module "Prosimo-Edge_AWS_ap-south-1" {
#   source = "./modules/Prosimo_Edge"
#   cloud_name = "AWS-Infra"
#   cloud_region = "ap-south-1"
#   ip_range = "192.168.64.0/23"
#   bandwidth = "<1 Gbps"
#   instance_type = "t3.medium"
#   deploy_edge = true
#   decommission_edge = false
# }


#Prosimo Infra for AWS

module "Prosimo-Edge_AWS_ap-south-1" {
  source = "./modules/Prosimo_Edge"
  cloud_name = "AWS-Infra"
  cloud_region = var.aws_region
  ip_range = var.edge_cidr
  bandwidth = "<1 Gbps"
  instance_type = "t3.medium"
  deploy_edge = true
  decommission_edge = false
}