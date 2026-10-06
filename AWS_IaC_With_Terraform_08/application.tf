locals {
  common_tags = {
    Terraform = "true"
    Project   = var.project_id
  }
}

data "aws_vpc" "existing" {
  filter {
    name   = "tag:Name"
    values = ["${var.project_id}-vpc"]
  }
}

data "aws_subnet" "public" {
  for_each = toset(var.public_subnet_cidrs)

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.existing.id]
  }

  filter {
    name   = "cidr-block"
    values = [each.value]
  }
}

data "aws_security_group" "ec2" {
  name   = "${var.project_id}-ec2_sg"
  vpc_id = data.aws_vpc.existing.id
}

data "aws_security_group" "http" {
  name   = "${var.project_id}-http_sg"
  vpc_id = data.aws_vpc.existing.id
}

data "aws_security_group" "load_balancer" {
  name   = "${var.project_id}-sglb"
  vpc_id = data.aws_vpc.existing.id
}

data "aws_ssm_parameter" "amazon_linux_2023_ami" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

resource "aws_launch_template" "application" {
  name          = "${var.project_id}-template"
  image_id      = data.aws_ssm_parameter.amazon_linux_2023_ami.value
  instance_type = var.instance_type
  key_name      = "${var.project_id}-keypair"

  iam_instance_profile {
    name = "${var.project_id}-instance_profile"
  }

  network_interfaces {
    associate_public_ip_address = true
    delete_on_termination       = true
    security_groups = [
      data.aws_security_group.ec2.id,
      data.aws_security_group.http.id,
    ]
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "optional"
  }

  user_data = base64encode(<<-EOF
    #!/bin/bash
    set -euo pipefail

    dnf update -y
    dnf install -y httpd jq
    systemctl enable --now httpd

    TOKEN=$(curl -fsS -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
    INSTANCE_ID=$(curl -fsS -H "X-aws-ec2-metadata-token: $TOKEN" "http://169.254.169.254/latest/meta-data/instance-id")
    PRIVATE_IP=$(curl -fsS -H "X-aws-ec2-metadata-token: $TOKEN" "http://169.254.169.254/latest/meta-data/local-ipv4")

    printf 'This message was generated on instance %s with the following IP: %s\n' "$INSTANCE_ID" "$PRIVATE_IP" > /var/www/html/index.html
    EOF
  )

  tag_specifications {
    resource_type = "instance"
    tags          = local.common_tags
  }

  tag_specifications {
    resource_type = "volume"
    tags          = local.common_tags
  }

  tags = local.common_tags
}

resource "aws_autoscaling_group" "application" {
  name                = "${var.project_id}-asg"
  desired_capacity    = var.desired_capacity
  min_size            = var.min_size
  max_size            = var.max_size
  vpc_zone_identifier = [for subnet in data.aws_subnet.public : subnet.id]

  launch_template {
    id      = aws_launch_template.application.id
    version = "$Latest"
  }

  dynamic "tag" {
    for_each = local.common_tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  lifecycle {
    ignore_changes = [load_balancers, target_group_arns]
  }
}

resource "aws_lb" "application" {
  name               = "${var.project_id}-loadbalancer"
  load_balancer_type = "application"
  internal           = false
  security_groups    = [data.aws_security_group.load_balancer.id]
  subnets            = [for subnet in data.aws_subnet.public : subnet.id]

  tags = local.common_tags
}

resource "aws_lb_target_group" "application" {
  name     = "${var.project_id}-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.existing.id

  health_check {
    path = "/"
  }

  tags = local.common_tags
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.application.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.application.arn
  }

  tags = local.common_tags
}

resource "aws_autoscaling_attachment" "application" {
  autoscaling_group_name = aws_autoscaling_group.application.id
  lb_target_group_arn    = aws_lb_target_group.application.arn
}
