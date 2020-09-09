provider "aws" {
  region = var.region
}

resource "aws_key_pair" "provision_key" {
  key_name = "softevol_perf_test_project_key"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
}

resource "aws_vpc" "se_perf_meter_project" {
  cidr_block = var.se_project_vpc_cidr_block

  tags = {
    Name = "softevol_perf_test_project VPC"
  }
}

resource "aws_security_group" "server_access_sg" {
  name        = "allow ssh"
  description = "softevol_perf_test_project Allow inbound ports from 0.0.0.0/0 (Any)"
  vpc_id      = aws_vpc.se_perf_meter_project.id

  dynamic "ingress" {
    for_each = var.meter_in_allowed_ports
    content {
      description = "softevol_perf_test_project Access from ANY"
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "softevol_perf_test_project server  Security Group"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.se_perf_meter_project.id
  cidr_block              = var.public_subnet_cidr_block
  availability_zone       = data.aws_availability_zones.available_azs.names[0]
  map_public_ip_on_launch = true
  depends_on              = [aws_internet_gateway.igw]

  tags = {
    Name = "softevol_perf_test_project Pub Subnet in ${data.aws_availability_zones.available_azs.names[0]}"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.se_perf_meter_project.id
  cidr_block        = var.private_subnet_cidr_block
  availability_zone = data.aws_availability_zones.available_azs.names[0]

  tags = {
    Name = "softevol_perf_test_project Priv Subnet in ${data.aws_availability_zones.available_azs.names[0]}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.se_perf_meter_project.id

  tags = {
    Name = "softevol_perf_test_project IGW for VPC"
  }
}

resource "aws_nat_gateway" "nat_gw" {
  depends_on = [aws_internet_gateway.igw]
  allocation_id = aws_eip.eip_ip_nat_gw.id
  subnet_id = aws_subnet.public_subnet.id
}

resource "aws_route_table" "pub_subnet_route_table" {
  vpc_id = aws_vpc.se_perf_meter_project.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  depends_on = [aws_internet_gateway.igw]

  tags = {
    Name = "softevol_perf_test_project Public Subnet Route table"
  }
}

resource "aws_route_table" "private_subnet_route_table" {
  vpc_id = aws_vpc.se_perf_meter_project.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gw.id
  }

  depends_on = [aws_internet_gateway.igw]

  tags = {
    Name = "softevol_perf_test_project Private Subnet Route table"
  }
}

resource "aws_route_table_association" "public_subnet" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.pub_subnet_route_table.id
}

resource "aws_route_table_association" "private_subnet" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_subnet_route_table.id
}

resource "aws_eip" "eip_ip_meter" {
  vpc        = true
  instance   = aws_instance.perf_meter_server.id
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_eip" "eip_ip_nat_gw" {
  vpc        = true
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_instance" "perf_meter_server" {
  ami             = data.aws_ami.latest_ubuntu.image_id
  instance_type   = var.meter_instance_type
  private_ip      = var.meter_instance_private_ip
  subnet_id       = aws_subnet.public_subnet.id
#  key_name        = aws_key_pair.generated_key.key_name
  key_name = aws_key_pair.provision_key.key_name
  security_groups = [aws_security_group.server_access_sg.id]

  tags = {
    Name = "Performance meter Server"
  }
}