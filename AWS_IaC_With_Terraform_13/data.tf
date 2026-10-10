data "aws_vpc" "existing" {
  filter {
    name   = "tag:Name"
    values = ["${var.project_id}-vpc"]
  }
}

data "aws_subnet" "public" {
  for_each = toset(var.public_subnet_names)

  filter {
    name   = "tag:Name"
    values = [each.value]
  }

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.existing.id]
  }
}

data "aws_security_group" "existing" {
  for_each = toset(["ssh", "http", "lb"])

  filter {
    name   = "tag:Name"
    values = ["${var.project_id}-sg-${each.value}"]
  }

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.existing.id]
  }
}

data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-kernel-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
