locals {
  environments = {
    blue  = "Blue Environment"
    green = "Green Environment"
  }

  common_tags = {
    Terraform = "true"
    Project   = var.project_id
  }

  public_subnet_ids = [for subnet in data.aws_subnet.public : subnet.id]
}

resource "aws_lb" "application" {
  name               = "${var.project_id}-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [data.aws_security_group.existing["lb"].id]
  subnets            = local.public_subnet_ids

  tags = merge(local.common_tags, {
    Name = "${var.project_id}-lb"
  })
}

resource "aws_lb_target_group" "environment" {
  for_each = local.environments

  name        = "${var.project_id}-${each.key}-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = data.aws_vpc.existing.id

  health_check {
    path     = "/"
    protocol = "HTTP"
    matcher  = "200"
  }

  tags = merge(local.common_tags, {
    Name        = "${var.project_id}-${each.key}-tg"
    Environment = each.key
  })
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.application.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "forward"

    forward {
      target_group {
        arn    = aws_lb_target_group.environment["blue"].arn
        weight = var.blue_weight
      }

      target_group {
        arn    = aws_lb_target_group.environment["green"].arn
        weight = var.green_weight
      }
    }
  }

  tags = local.common_tags

  lifecycle {
    precondition {
      condition     = var.blue_weight + var.green_weight > 0
      error_message = "At least one environment must have a positive traffic weight."
    }
  }
}

resource "aws_launch_template" "environment" {
  for_each = local.environments

  name          = "${var.project_id}-${each.key}-template"
  image_id      = data.aws_ami.amazon_linux_2023.id
  instance_type = var.instance_type

  network_interfaces {
    device_index                = 0
    associate_public_ip_address = true
    delete_on_termination       = true
    security_groups = [
      data.aws_security_group.existing["ssh"].id,
      data.aws_security_group.existing["http"].id,
    ]
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  user_data = base64encode(<<-EOF
    #!/bin/bash
    set -euo pipefail

    dnf update -y
    dnf install -y httpd

    cat > /var/www/html/index.html <<'HTML'
    <!doctype html>
    <html lang="en">
      <head><meta charset="utf-8"><title>${each.value}</title></head>
      <body><h1>${each.value}</h1></body>
    </html>
    HTML

    systemctl enable --now httpd
    EOF
  )

  dynamic "tag_specifications" {
    for_each = toset(["instance", "volume"])

    content {
      resource_type = tag_specifications.value
      tags = merge(local.common_tags, {
        Name        = "${var.project_id}-${each.key}-instance"
        Environment = each.key
      })
    }
  }

  tags = merge(local.common_tags, {
    Name        = "${var.project_id}-${each.key}-template"
    Environment = each.key
  })
}

resource "aws_autoscaling_group" "environment" {
  for_each = local.environments

  name                      = "${var.project_id}-${each.key}-asg"
  desired_capacity          = var.desired_capacity
  min_size                  = var.min_size
  max_size                  = var.max_size
  vpc_zone_identifier       = local.public_subnet_ids
  target_group_arns         = [aws_lb_target_group.environment[each.key].arn]
  health_check_type         = "ELB"
  health_check_grace_period = 300

  launch_template {
    id      = aws_launch_template.environment[each.key].id
    version = tostring(aws_launch_template.environment[each.key].latest_version)
  }

  dynamic "tag" {
    for_each = merge(local.common_tags, {
      Name        = "${var.project_id}-${each.key}-instance"
      Environment = each.key
    })

    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  depends_on = [aws_lb_listener.http]
}
