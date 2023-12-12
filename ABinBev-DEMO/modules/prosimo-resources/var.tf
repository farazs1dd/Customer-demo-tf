variable "prosimo_teamName" {
  type = string
}
variable "prosimo_token" {
  type = string
}
variable "cloud1" {
  type = string
}

variable "my_condition" {
  type = bool
}

variable "prosimo_cidr" {
  type = string
}

variable "cloud" {
  type = string
}

variable "bandwidth" {
  type = string
  description = "Valid BW for AWS Edge GW"
  default = ""

}
variable "instance_type" {
  type = string
  description = "Instance size for AWS Edge GW"
  default = ""

}

variable "multipleRegion" {
  type = string
}

variable "wait" {
  type = bool
}

