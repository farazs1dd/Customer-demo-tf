resource "prosimo_edge" "edge" {
cloud_name = var.cloud_name
cloud_region = var.cloud_region
ip_range = var.ip_range
node_size_settings {
bandwidth = var.bandwidth
instance_type =var.instance_type
}
deploy_edge = var.deploy_edge
decommission_edge = var.decommission_edge
}