variable "region" {
  type    = string
  default = "eu-central-1"
}

variable "avz" {
  type    = string
  default = "eu-central-1a"
}

variable "key_name" {
  type    = string
  default = "pub_key"
}

variable "meter_in_allowed_ports" {
  description = "Allow ports to Backend server - Inbound"
  type        = list
  default     = ["22","2222"]
}


variable "meter_instance_type" {
  type    = string
  default = "t2.nano"
}

variable "se_project_vpc_cidr_block" {
  type    = string
  default = "192.168.0.0/16"
}

variable "public_subnet_cidr_block" {
  type    = string
  default = "192.168.60.0/24"
}

variable "private_subnet_cidr_block" {
  type    = string
  default = "192.168.50.0/24"
}

variable "meter_instance_private_ip" {
  type    = string
  default = "192.168.60.10"
}

variable "PATH_TO_PRIVATE_KEY" {
  default = "/home/gorovoy/.ssh/se_id_rsa"
}
variable "PATH_TO_PUBLIC_KEY" {
  default = "/home/gorovoy/.ssh/se_id_rsa.pub"
}
variable "INSTANCE_USERNAME" {
  default = "ubuntu"
}
