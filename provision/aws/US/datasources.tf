data "aws_availability_zones" "available_azs" {
  state = "available"
}

data "aws_ami" "latest_ubuntu" {
  most_recent = "true"
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-*"]
  }
}

data "aws_ami" "latest_amznlinux" {
  most_recent = "true"
  owners      = ["137112412989"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.20200617.0-x86_64-gp2*"]
  }
}
