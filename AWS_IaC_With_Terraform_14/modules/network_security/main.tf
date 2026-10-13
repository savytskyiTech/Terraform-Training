resource "aws_security_group" "ssh" {
  name        = var.security_group_names.ssh
  description = "SSH from the platform and your public IP."
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH from the allowed IPv4 ranges."
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_ip_range
  }

  egress {
    description = "Outbound traffic for package installation."
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { Name = var.security_group_names.ssh })
}

resource "aws_security_group" "public_http" {
  name        = var.security_group_names.public_http
  description = "HTTP to the load balancer from the platform and your public IP."
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP from the allowed IPv4 ranges."
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.allowed_ip_range
  }

  egress {
    description = "Outbound traffic to application instances."
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { Name = var.security_group_names.public_http })
}

resource "aws_security_group" "private_http" {
  name        = var.security_group_names.private_http
  description = "HTTP to application instances from the load balancer security group."
  vpc_id      = var.vpc_id

  ingress {
    description     = "HTTP from the public HTTP security group."
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.public_http.id]
  }

  egress {
    description = "Outbound traffic for package installation."
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { Name = var.security_group_names.private_http })
}
