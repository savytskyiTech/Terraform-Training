data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = [var.ami_name_pattern]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_launch_template" "this" {
  name          = var.resource_names.launch_template
  image_id      = data.aws_ami.amazon_linux_2023.id
  instance_type = var.instance_type

  network_interfaces {
    device_index                = 0
    associate_public_ip_address = true
    delete_on_termination       = true
    security_groups = [
      var.security_group_ids.ssh,
      var.security_group_ids.private_http,
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

    COMPUTE_MACHINE_UUID=$(cat /sys/devices/virtual/dmi/id/product_uuid | tr '[:upper:]' '[:lower:]')
    TOKEN=$(curl -fsS --retry 5 -X PUT \
      -H 'X-aws-ec2-metadata-token-ttl-seconds: 21600' \
      http://169.254.169.254/latest/api/token)
    COMPUTE_INSTANCE_ID=$(curl -fsS --retry 5 \
      -H "X-aws-ec2-metadata-token: $TOKEN" \
      http://169.254.169.254/latest/meta-data/instance-id)

    printf '<!doctype html><html><body><p>This message was generated on instance %s with the following UUID %s</p></body></html>\n' \
      "$COMPUTE_INSTANCE_ID" "$COMPUTE_MACHINE_UUID" > /var/www/html/index.html

    systemctl enable --now httpd
    EOF
  )

  dynamic "tag_specifications" {
    for_each = toset(["instance", "volume"])

    content {
      resource_type = tag_specifications.value
      tags          = merge(var.tags, { Name = var.resource_names.instance })
    }
  }

  tags = merge(var.tags, { Name = var.resource_names.launch_template })
}

resource "aws_lb" "this" {
  name               = var.resource_names.load_balancer
  internal           = false
  load_balancer_type = "application"
  subnets            = var.subnet_ids
  security_groups    = [var.security_group_ids.public_http]

  tags = merge(var.tags, { Name = var.resource_names.load_balancer })
}

resource "aws_lb_target_group" "this" {
  name        = var.resource_names.target_group
  vpc_id      = var.vpc_id
  target_type = "instance"
  port        = 80
  protocol    = "HTTP"

  health_check {
    path     = "/"
    protocol = "HTTP"
    matcher  = "200"
  }

  tags = merge(var.tags, { Name = var.resource_names.target_group })
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }

  tags = var.tags
}

resource "aws_autoscaling_group" "this" {
  name                      = var.resource_names.autoscaling
  desired_capacity          = var.desired_capacity
  min_size                  = var.min_size
  max_size                  = var.max_size
  vpc_zone_identifier       = var.subnet_ids
  health_check_type         = "ELB"
  health_check_grace_period = 300

  launch_template {
    id      = aws_launch_template.this.id
    version = tostring(aws_launch_template.this.latest_version)
  }

  dynamic "tag" {
    for_each = merge(var.tags, { Name = var.resource_names.instance })

    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  lifecycle {
    ignore_changes = [load_balancers, target_group_arns]
  }

  depends_on = [aws_lb_listener.http]
}

resource "aws_autoscaling_attachment" "this" {
  autoscaling_group_name = aws_autoscaling_group.this.name
  lb_target_group_arn    = aws_lb_target_group.this.arn
}
