data "aws_vpc" "existing" {
  filter {
    name   = "tag:Name"
    values = ["${var.resource_id}-vpc"]
  }
}

data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.existing.id]
  }
}

data "aws_security_group" "existing" {
  filter {
    name   = "group-name"
    values = ["${var.resource_id}-sg"]
  }
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "main" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = var.instance_type
  subnet_id                   = data.aws_subnets.public.ids[0]
  vpc_security_group_ids      = [data.aws_security_group.existing.id]
  key_name                    = aws_key_pair.main.key_name
  associate_public_ip_address = true

  tags = {
    Name    = "${var.resource_id}-ec2"
    Project = var.project_name
    ID      = var.resource_id
  }
}