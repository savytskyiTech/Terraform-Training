data "aws_network_interface" "public" {
  filter {
    name   = "attachment.instance-id"
    values = [var.public_instance_id]
  }

  filter {
    name   = "attachment.device-index"
    values = ["0"]
  }

  filter {
    name   = "subnet-id"
    values = [var.public_subnet_id]
  }
}

data "aws_network_interface" "private" {
  filter {
    name   = "attachment.instance-id"
    values = [var.private_instance_id]
  }

  filter {
    name   = "attachment.device-index"
    values = ["0"]
  }

  filter {
    name   = "subnet-id"
    values = [var.private_subnet_id]
  }
}

resource "aws_security_group" "ssh" {
  name        = "${var.project_id}-ssh-sg"
  description = "SSH and ICMP access from allowed IP ranges"
  vpc_id      = var.vpc_id

  tags = {
    Project = var.project_id
  }
}

resource "aws_security_group" "public_http" {
  name        = "${var.project_id}-public-http-sg"
  description = "HTTP and ICMP access from allowed IP ranges"
  vpc_id      = var.vpc_id

  tags = {
    Project = var.project_id
  }
}

resource "aws_security_group" "private_http" {
  name        = "${var.project_id}-private-http-sg"
  description = "Private HTTP and ICMP access from the public HTTP security group"
  vpc_id      = var.vpc_id

  tags = {
    Project = var.project_id
  }
}

resource "aws_security_group_rule" "ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = var.allowed_ip_range
  security_group_id = aws_security_group.ssh.id
}

resource "aws_security_group_rule" "ssh_icmp" {
  type              = "ingress"
  from_port         = -1
  to_port           = -1
  protocol          = "icmp"
  cidr_blocks       = var.allowed_ip_range
  security_group_id = aws_security_group.ssh.id
}

resource "aws_security_group_rule" "public_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = var.allowed_ip_range
  security_group_id = aws_security_group.public_http.id
}

resource "aws_security_group_rule" "public_http_icmp" {
  type              = "ingress"
  from_port         = -1
  to_port           = -1
  protocol          = "icmp"
  cidr_blocks       = var.allowed_ip_range
  security_group_id = aws_security_group.public_http.id
}

resource "aws_security_group_rule" "private_http" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.public_http.id
  security_group_id        = aws_security_group.private_http.id
}

resource "aws_security_group_rule" "private_http_icmp" {
  type                     = "ingress"
  from_port                = -1
  to_port                  = -1
  protocol                 = "icmp"
  source_security_group_id = aws_security_group.public_http.id
  security_group_id        = aws_security_group.private_http.id
}

resource "aws_network_interface_sg_attachment" "public_ssh" {
  security_group_id    = aws_security_group.ssh.id
  network_interface_id = data.aws_network_interface.public.id
}

resource "aws_network_interface_sg_attachment" "public_http" {
  security_group_id    = aws_security_group.public_http.id
  network_interface_id = data.aws_network_interface.public.id

  depends_on = [aws_network_interface_sg_attachment.public_ssh]
}

resource "aws_network_interface_sg_attachment" "private_ssh" {
  security_group_id    = aws_security_group.ssh.id
  network_interface_id = data.aws_network_interface.private.id
}

resource "aws_network_interface_sg_attachment" "private_http" {
  security_group_id    = aws_security_group.private_http.id
  network_interface_id = data.aws_network_interface.private.id

  depends_on = [aws_network_interface_sg_attachment.private_ssh]
}
